package com.helios.web.portfolio.stats

import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.File
import java.security.MessageDigest
import java.security.SecureRandom
import java.time.LocalDate
import java.time.ZoneId
import java.util.Locale

private val ZONE: ZoneId = ZoneId.of("Asia/Ho_Chi_Minh")

/** Crawlers we never count. Matched case-insensitively against the User-Agent. */
private val BOT_PATTERN = Regex(
    "bot|crawl|spider|slurp|bingpreview|facebookexternalhit|whatsapp|telegram|discord|" +
        "curl|wget|python-requests|okhttp|headless|lighthouse|pingdom|uptime|monitor|scan",
    RegexOption.IGNORE_CASE
)

@Serializable
data class DayCount(val site: Long = 0, val resume: Long = 0)

@Serializable
data class StatsData(
    val siteTotal: Long = 0,
    val resumeTotal: Long = 0,
    val days: Map<String, DayCount> = emptyMap(),
    // Visitor de-duplication is only ever needed for the current day, so the seen-sets
    // are dropped when the date rolls over. That keeps the file from growing without bound.
    val seenDate: String = "",
    val seenSite: Set<String> = emptySet(),
    val seenResume: Set<String> = emptySet(),
    // Generated once. Without it the stored hashes could be brute-forced back to IPs.
    val salt: String = ""
)

enum class Target { SITE, RESUME }

/**
 * Counts unique daily visitors to the site and the resume.
 *
 * Requests mutate in-memory state only; [flush] writes to disk. Callers are expected to flush
 * periodically and on shutdown, so a container restart loses at most one flush interval.
 */
class StatsStore(private val file: File) {

    private val json = Json { prettyPrint = true; ignoreUnknownKeys = true }
    private val mutex = Mutex()
    private var data: StatsData = read()
    private var dirty = false

    private fun read(): StatsData {
        val loaded = runCatching {
            if (file.exists()) json.decodeFromString<StatsData>(file.readText()) else null
        }.getOrNull() ?: StatsData()

        return if (loaded.salt.isBlank()) loaded.copy(salt = newSalt()) else loaded
    }

    private fun newSalt(): String {
        val bytes = ByteArray(16).also { SecureRandom().nextBytes(it) }
        return bytes.joinToString("") { "%02x".format(it) }
    }

    private fun fingerprint(ip: String, salt: String): String {
        val digest = MessageDigest.getInstance("SHA-256").digest("$salt|$ip".toByteArray())
        // 8 bytes is ample to separate visitors within a single day.
        return digest.take(8).joinToString("") { "%02x".format(it) }
    }

    /**
     * Records one view. Returns false when the request was ignored: a crawler, or a visitor
     * already counted for [target] today.
     */
    suspend fun record(target: Target, ip: String?, userAgent: String?): Boolean = mutex.withLock {
        if (userAgent == null || BOT_PATTERN.containsMatchIn(userAgent)) return false
        if (ip.isNullOrBlank()) return false

        val today = LocalDate.now(ZONE).toString()
        var current = data
        if (current.seenDate != today) {
            current = current.copy(seenDate = today, seenSite = emptySet(), seenResume = emptySet())
        }

        val id = fingerprint(ip, current.salt)
        val seen = if (target == Target.SITE) current.seenSite else current.seenResume
        if (id in seen) {
            data = current
            return false
        }

        val day = current.days[today] ?: DayCount()
        data = when (target) {
            Target.SITE -> current.copy(
                siteTotal = current.siteTotal + 1,
                days = current.days + (today to day.copy(site = day.site + 1)),
                seenSite = current.seenSite + id
            )
            Target.RESUME -> current.copy(
                resumeTotal = current.resumeTotal + 1,
                days = current.days + (today to day.copy(resume = day.resume + 1)),
                seenResume = current.seenResume + id
            )
        }
        dirty = true
        return true
    }

    /** Writes through a temp file so a crash mid-write cannot truncate the real one. */
    suspend fun flush() = mutex.withLock {
        if (!dirty) return@withLock
        val tmp = File(file.parentFile, "${file.name}.tmp")
        tmp.writeText(json.encodeToString(data))
        tmp.renameTo(file)
        dirty = false
    }

    suspend fun snapshot(days: Int = 30): StatsView = mutex.withLock {
        val today = LocalDate.now(ZONE)
        val recent = (0 until days).map { today.minusDays(it.toLong()) }.map { date ->
            val key = date.toString()
            val counts = data.days[key] ?: DayCount()
            DayView(
                date = key,
                label = date.format(java.time.format.DateTimeFormatter.ofPattern("d MMM", Locale.ENGLISH)),
                site = counts.site,
                resume = counts.resume
            )
        }.reversed()

        StatsView(
            siteTotal = data.siteTotal,
            resumeTotal = data.resumeTotal,
            today = recent.lastOrNull() ?: DayView(today.toString(), "", 0, 0),
            days = recent,
            maxCount = maxOf(1, recent.maxOfOrNull { maxOf(it.site, it.resume) } ?: 1),
            conversion = if (data.siteTotal == 0L) 0
                         else Math.round(data.resumeTotal * 100.0 / data.siteTotal).toInt()
        )
    }
}

data class DayView(val date: String, val label: String, val site: Long, val resume: Long)

data class StatsView(
    val siteTotal: Long,
    val resumeTotal: Long,
    val today: DayView,
    val days: List<DayView>,
    val maxCount: Long,
    val conversion: Int
)
