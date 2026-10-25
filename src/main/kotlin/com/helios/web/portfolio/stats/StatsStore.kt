package com.helios.web.portfolio.stats

import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.File
import java.security.MessageDigest
import java.security.SecureRandom
import java.time.Clock
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit
import java.util.Locale

val STATS_ZONE: ZoneId = ZoneId.of("Asia/Ho_Chi_Minh")

/** Crawlers we never count. Matched case-insensitively against the User-Agent. */
private val BOT_PATTERN = Regex(
    "bot|crawl|spider|slurp|bingpreview|facebookexternalhit|whatsapp|telegram|discord|" +
        "curl|wget|python-requests|okhttp|headless|lighthouse|pingdom|uptime|monitor|scan",
    RegexOption.IGNORE_CASE
)

/** Distinct sources kept before new ones are folded into [OTHER_SOURCE]. Bounds the file size. */
private const val MAX_SOURCES = 100

/** Distinct résumé links kept. Anyone can open any /r/<name>, so the list must be bounded. */
const val MAX_RESUME_LINKS = 300

const val OTHER_SOURCE = "other"

@Serializable
data class DayCount(
    val site: Long = 0,
    val resume: Long = 0,
    /** Unique site visitors per source on this day. */
    val siteSources: Map<String, Long> = emptyMap(),
    /** Unique résumé opens per source on this day. */
    val resumeSources: Map<String, Long> = emptyMap(),
)

@Serializable
data class SourceCount(val site: Long = 0, val resume: Long = 0)

@Serializable
data class LinkCount(
    /** Unique visitors per day, summed. A visitor reopening the same link the same day counts once. */
    val opens: Long = 0,
    /** Local date-times in [STATS_ZONE], ISO format. */
    val firstOpened: String = "",
    val lastOpened: String = "",
)

@Serializable
data class StatsData(
    val siteTotal: Long = 0,
    val resumeTotal: Long = 0,
    val days: Map<String, DayCount> = emptyMap(),
    /** All-time unique visitors per source, counted from [sourcesSince]. */
    val sources: Map<String, SourceCount> = emptyMap(),
    /** ISO date source tracking started. Visitors before it are in the totals but not in [sources]. */
    val sourcesSince: String = "",
    val resumeLinks: Map<String, LinkCount> = emptyMap(),
    // Visitor de-duplication is only ever needed for the current day, so the seen-sets
    // are dropped when the date rolls over. That keeps the file from growing without bound.
    val seenDate: String = "",
    val seenSite: Set<String> = emptySet(),
    val seenResume: Set<String> = emptySet(),
    /** "<link>|<visitor>" pairs already counted today. */
    val seenLinks: Set<String> = emptySet(),
    /**
     * Where each of today's site visitors came from. A résumé opened from the site arrives with
     * the site itself as referrer, so this credits it to the source that brought the visitor.
     */
    val seenSiteSource: Map<String, String> = emptyMap(),
    // Generated once. Without it the stored hashes could be brute-forced back to IPs.
    val salt: String = ""
)

enum class Target { SITE, RESUME }

/**
 * Counts unique daily visitors to the site and the resume, where they came from, and who opened
 * which résumé link.
 *
 * Requests mutate in-memory state only; [flush] writes to disk. Callers are expected to flush
 * periodically and on shutdown, so a container restart loses at most one flush interval.
 */
class StatsStore(
    private val file: File,
    private val clock: Clock = Clock.system(STATS_ZONE),
) {

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

    private fun isCountable(ip: String?, userAgent: String?): Boolean =
        userAgent != null && !BOT_PATTERN.containsMatchIn(userAgent) && !ip.isNullOrBlank()

    /** Today's state, with the seen-sets reset if the date rolled over since the last request. */
    private fun rolledOver(today: String): StatsData {
        val current = data
        if (current.seenDate == today) return current
        return current.copy(
            seenDate = today,
            seenSite = emptySet(),
            seenResume = emptySet(),
            seenLinks = emptySet(),
            seenSiteSource = emptyMap()
        )
    }

    /**
     * Records one view arriving from [source] (see [trafficSource]). Returns false when the
     * request was ignored: a crawler, or a visitor already counted for [target] today.
     *
     * A résumé view whose source is the site itself is credited to the source that brought the
     * visitor to the site today, when known.
     */
    suspend fun record(
        target: Target,
        ip: String?,
        userAgent: String?,
        source: String = DIRECT_SOURCE,
        siteHost: String? = null,
    ): Boolean = mutex.withLock {
        if (!isCountable(ip, userAgent)) return false

        val today = LocalDate.now(clock).toString()
        val current = rolledOver(today)

        val id = fingerprint(ip!!, current.salt)
        val seen = if (target == Target.SITE) current.seenSite else current.seenResume
        if (id in seen) {
            data = current
            return false
        }

        val attributed = if (target == Target.RESUME && siteHost != null && source == siteHost) {
            current.seenSiteSource[id] ?: source
        } else {
            source
        }
        val key = sourceKey(current.sources, attributed)
        val day = current.days[today] ?: DayCount()
        val total = current.sources[key] ?: SourceCount()

        data = when (target) {
            Target.SITE -> current.copy(
                siteTotal = current.siteTotal + 1,
                days = current.days + (today to day.copy(
                    site = day.site + 1,
                    siteSources = day.siteSources.increment(key)
                )),
                sources = current.sources + (key to total.copy(site = total.site + 1)),
                seenSite = current.seenSite + id,
                seenSiteSource = current.seenSiteSource + (id to key)
            )
            Target.RESUME -> current.copy(
                resumeTotal = current.resumeTotal + 1,
                days = current.days + (today to day.copy(
                    resume = day.resume + 1,
                    resumeSources = day.resumeSources.increment(key)
                )),
                sources = current.sources + (key to total.copy(resume = total.resume + 1)),
                seenResume = current.seenResume + id
            )
        }.let { if (it.sourcesSince.isBlank()) it.copy(sourcesSince = today) else it }
        dirty = true
        return true
    }

    /**
     * Records an open of the tracked résumé link [link]. Returns false when ignored: a crawler,
     * a visitor who already opened this link today, or a new link once [MAX_RESUME_LINKS] exist.
     */
    suspend fun recordResumeLink(link: String, ip: String?, userAgent: String?): Boolean = mutex.withLock {
        if (!isCountable(ip, userAgent)) return false

        val now = LocalDateTime.now(clock).truncatedTo(ChronoUnit.SECONDS)
        val current = rolledOver(now.toLocalDate().toString())

        val existing = current.resumeLinks[link]
        if (existing == null && current.resumeLinks.size >= MAX_RESUME_LINKS) {
            data = current
            return false
        }

        val seenKey = "$link|${fingerprint(ip!!, current.salt)}"
        if (seenKey in current.seenLinks) {
            data = current
            return false
        }

        val stamp = now.toString()
        val count = existing ?: LinkCount(firstOpened = stamp)
        data = current.copy(
            resumeLinks = current.resumeLinks + (link to count.copy(opens = count.opens + 1, lastOpened = stamp)),
            seenLinks = current.seenLinks + seenKey
        )
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
        val today = LocalDate.now(clock)
        val dayLabel = DateTimeFormatter.ofPattern("d MMM", Locale.ENGLISH)
        val recent = (0 until days).map { today.minusDays(it.toLong()) }.map { date ->
            val key = date.toString()
            val counts = data.days[key] ?: DayCount()
            DayView(
                date = key,
                label = date.format(dayLabel),
                site = counts.site,
                resume = counts.resume
            )
        }.reversed()

        val week = window(today, 0)
        StatsView(
            siteTotal = data.siteTotal,
            resumeTotal = data.resumeTotal,
            today = recent.lastOrNull() ?: DayView(today.toString(), "", 0, 0),
            days = recent,
            maxCount = maxOf(1, recent.maxOfOrNull { maxOf(it.site, it.resume) } ?: 1),
            conversion = percent(data.resumeTotal, data.siteTotal),
            sourcesSince = data.sourcesSince.takeIf { it.isNotBlank() }
                ?.let { LocalDate.parse(it).format(SINCE_LABEL) } ?: "",
            sources = data.sources
                .map { (name, count) -> SourceView(name, count.site, count.resume) }
                .sortedWith(compareByDescending<SourceView> { it.site }.thenByDescending { it.resume }.thenBy { it.name }),
            week = week,
            previousWeek = window(today, 7),
            sourceRows = sourceRows(week),
            links = data.resumeLinks
                .map { (name, count) ->
                    LinkView(
                        name = name,
                        opens = count.opens,
                        firstOpened = count.firstOpened,
                        lastOpened = count.lastOpened,
                        firstOpenedLabel = LocalDateTime.parse(count.firstOpened).format(OPENED_LABEL),
                        lastOpenedLabel = LocalDateTime.parse(count.lastOpened).format(OPENED_LABEL)
                    )
                }
                .sortedByDescending { it.lastOpened }
        )
    }

    /** The [SOURCE_ROWS] biggest all-time sources with their last-7-days numbers alongside. */
    private fun sourceRows(week: WindowView): List<SourceRow> {
        val weekSite = week.sources.associate { it.name to it.site }
        val totalSite = data.sources.values.sumOf { it.site }
        return data.sources.entries
            .sortedWith(compareByDescending<Map.Entry<String, SourceCount>> { it.value.site }
                .thenByDescending { it.value.resume }.thenBy { it.key })
            .take(SOURCE_ROWS)
            .map { (name, count) ->
                SourceRow(
                    name = name,
                    weekSite = weekSite[name] ?: 0,
                    site = count.site,
                    resume = count.resume,
                    share = percent(count.site, totalSite)
                )
            }
    }

    /** Totals for the 7 days ending [offset] days before [today], newest day included. */
    private fun window(today: LocalDate, offset: Long): WindowView {
        val dates = (offset until offset + 7).map { today.minusDays(it).toString() }
        val counts = dates.mapNotNull { data.days[it] }
        val site = counts.sumOf { it.site }
        val resume = counts.sumOf { it.resume }
        val siteBySource = counts.flatMap { it.siteSources.entries }.groupBy({ it.key }, { it.value })
        val resumeBySource = counts.flatMap { it.resumeSources.entries }.groupBy({ it.key }, { it.value })
        val sources = (siteBySource.keys + resumeBySource.keys).map { name ->
            SourceView(name, siteBySource[name]?.sum() ?: 0, resumeBySource[name]?.sum() ?: 0)
        }.sortedWith(compareByDescending<SourceView> { it.site }.thenByDescending { it.resume }.thenBy { it.name })
        return WindowView(
            from = dates.last(),
            to = dates.first(),
            site = site,
            resume = resume,
            sources = sources
        )
    }
}

private const val SOURCE_ROWS = 15

private val SINCE_LABEL = DateTimeFormatter.ofPattern("d MMM yyyy", Locale.ENGLISH)
private val OPENED_LABEL = DateTimeFormatter.ofPattern("d MMM yyyy, HH:mm", Locale.ENGLISH)

private fun percent(part: Long, whole: Long): Int =
    if (whole == 0L) 0 else Math.round(part * 100.0 / whole).toInt()

private fun Map<String, Long>.increment(key: String): Map<String, Long> = this + (key to (this[key] ?: 0) + 1)

/** [source] itself while there is room or it is already tracked, otherwise [OTHER_SOURCE]. */
private fun sourceKey(existing: Map<String, SourceCount>, source: String): String =
    if (source in existing || existing.size < MAX_SOURCES) source else OTHER_SOURCE

@Serializable
data class DayView(val date: String, val label: String, val site: Long, val resume: Long)

@Serializable
data class SourceView(val name: String, val site: Long, val resume: Long)

@Serializable
data class WindowView(
    /** Inclusive ISO dates. */
    val from: String,
    val to: String,
    val site: Long,
    val resume: Long,
    val sources: List<SourceView>,
)

@Serializable
data class LinkView(
    val name: String,
    val opens: Long,
    val firstOpened: String,
    val lastOpened: String,
    val firstOpenedLabel: String,
    val lastOpenedLabel: String,
)

/** One row of the sources table on /stats. */
@Serializable
data class SourceRow(
    val name: String,
    /** Unique site visitors in the last 7 days. */
    val weekSite: Long,
    /** All-time unique site visitors. */
    val site: Long,
    /** All-time unique résumé opens. */
    val resume: Long,
    /** Share of all-time site visitors with a known source, in percent. */
    val share: Int,
)

@Serializable
data class StatsView(
    val siteTotal: Long,
    val resumeTotal: Long,
    val today: DayView,
    val days: List<DayView>,
    val maxCount: Long,
    val conversion: Int,
    /** Display date source tracking started, empty before the first tracked visit. */
    val sourcesSince: String,
    /** All time, most site visitors first. */
    val sources: List<SourceView>,
    /** The biggest sources, ready for the /stats table. */
    val sourceRows: List<SourceRow>,
    /** The last 7 days including today. */
    val week: WindowView,
    /** The 7 days before [week]. */
    val previousWeek: WindowView,
    /** Most recently opened first. */
    val links: List<LinkView>,
)
