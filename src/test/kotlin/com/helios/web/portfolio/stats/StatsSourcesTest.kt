package com.helios.web.portfolio.stats

import kotlinx.coroutines.runBlocking
import java.io.File
import java.nio.file.Files
import java.time.Duration
import java.time.LocalDateTime
import kotlin.test.AfterTest
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

private const val BROWSER =
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36"
private const val SITE_HOST = "phpduy.dev"

class StatsSourcesTest {

    private val dir: File = Files.createTempDirectory("stats-sources").toFile()
    private val clock = MutableClock(LocalDateTime.of(2026, 10, 20, 9, 30))
    private fun store() = StatsStore(File(dir, "stats.json"), clock)

    @AfterTest
    fun cleanup() {
        dir.deleteRecursively()
    }

    @Test
    fun `counts site visitors per source`() = runBlocking {
        val store = store()
        store.record(Target.SITE, "1.1.1.1", BROWSER, "linkedin.com")
        store.record(Target.SITE, "2.2.2.2", BROWSER, "linkedin.com")
        store.record(Target.SITE, "3.3.3.3", BROWSER, "google")

        val sources = store.snapshot().sources.associate { it.name to it.site }
        assertEquals(mapOf("linkedin.com" to 2L, "google" to 1L), sources)
    }

    @Test
    fun `a cv opened from the site is credited to the visitor's original source`() = runBlocking {
        val store = store()
        store.record(Target.SITE, "1.1.1.1", BROWSER, "linkedin.com", SITE_HOST)
        store.record(Target.RESUME, "1.1.1.1", BROWSER, SITE_HOST, SITE_HOST)

        val linkedin = store.snapshot().sources.single { it.name == "linkedin.com" }
        assertEquals(1, linkedin.site)
        assertEquals(1, linkedin.resume)
    }

    @Test
    fun `a cv opened from the site with no earlier visit today keeps the site as source`() = runBlocking {
        val store = store()
        store.record(Target.RESUME, "1.1.1.1", BROWSER, SITE_HOST, SITE_HOST)

        assertEquals(listOf(SourceView(SITE_HOST, 0, 1)), store.snapshot().sources)
    }

    @Test
    fun `week and previous week split by date`() = runBlocking {
        val store = store()
        store.record(Target.SITE, "1.1.1.1", BROWSER, "google")
        clock.advance(Duration.ofDays(7))
        store.record(Target.SITE, "1.1.1.1", BROWSER, "linkedin.com")
        store.record(Target.RESUME, "1.1.1.1", BROWSER, "linkedin.com")

        val snap = store.snapshot()
        assertEquals("2026-10-21", snap.week.from)
        assertEquals("2026-10-27", snap.week.to)
        assertEquals(1, snap.week.site)
        assertEquals(1, snap.week.resume)
        assertEquals(listOf(SourceView("linkedin.com", 1, 1)), snap.week.sources)
        assertEquals(1, snap.previousWeek.site)
        assertEquals(listOf(SourceView("google", 1, 0)), snap.previousWeek.sources)
        assertEquals(1, snap.sourceRows.single { it.name == "linkedin.com" }.weekSite)
        assertEquals(0, snap.sourceRows.single { it.name == "google" }.weekSite)
    }

    @Test
    fun `sources beyond the cap fold into other`() = runBlocking {
        val store = store()
        repeat(100) { store.record(Target.SITE, "10.0.0.$it", BROWSER, "site$it.example") }
        store.record(Target.SITE, "10.0.1.1", BROWSER, "one-too-many.example")
        store.record(Target.SITE, "10.0.1.2", BROWSER, "site0.example")

        val sources = store.snapshot().sources.associate { it.name to it.site }
        assertEquals(101, sources.size)
        assertEquals(1, sources[OTHER_SOURCE])
        assertEquals(2, sources["site0.example"])
    }

    @Test
    fun `resume links count each visitor once per day and keep first and last open`() = runBlocking {
        val store = store()
        assertTrue(store.recordResumeLink("acme", "1.1.1.1", BROWSER))
        clock.advance(Duration.ofHours(2))
        assertFalse(store.recordResumeLink("acme", "1.1.1.1", BROWSER), "same visitor, same day")
        assertTrue(store.recordResumeLink("acme", "2.2.2.2", BROWSER))
        clock.advance(Duration.ofDays(1))
        assertTrue(store.recordResumeLink("acme", "1.1.1.1", BROWSER), "same visitor, next day")

        val acme = store.snapshot().links.single()
        assertEquals("acme", acme.name)
        assertEquals(3, acme.opens)
        assertEquals("2026-10-20T09:30", acme.firstOpened.substring(0, 16))
        assertEquals("2026-10-21T11:30", acme.lastOpened.substring(0, 16))
        assertEquals("21 Oct 2026, 11:30", acme.lastOpenedLabel)
    }

    @Test
    fun `resume links ignore crawlers and stop accepting new names at the cap`() = runBlocking {
        val store = store()
        assertFalse(store.recordResumeLink("acme", "1.1.1.1", "Googlebot/2.1"))
        repeat(MAX_RESUME_LINKS) { store.recordResumeLink("company-$it", "1.1.1.1", BROWSER) }
        assertFalse(store.recordResumeLink("one-more", "1.1.1.1", BROWSER))
        assertTrue(store.recordResumeLink("company-0", "2.2.2.2", BROWSER), "existing names keep counting")
        assertEquals(MAX_RESUME_LINKS, store.snapshot().links.size)
    }

    @Test
    fun `links are listed most recently opened first`() = runBlocking {
        val store = store()
        store.recordResumeLink("first", "1.1.1.1", BROWSER)
        clock.advance(Duration.ofMinutes(5))
        store.recordResumeLink("second", "1.1.1.1", BROWSER)

        assertEquals(listOf("second", "first"), store.snapshot().links.map { it.name })
    }

    @Test
    fun `reads a stats file written before sources and links existed`() = runBlocking {
        File(dir, "stats.json").writeText(
            """
            {
              "siteTotal": 42,
              "resumeTotal": 7,
              "days": { "2026-10-20": { "site": 3, "resume": 1 } },
              "seenDate": "2026-10-20",
              "seenSite": ["aaaaaaaaaaaaaaaa"],
              "seenResume": [],
              "salt": "0123456789abcdef0123456789abcdef"
            }
            """.trimIndent()
        )
        val store = store()
        store.record(Target.SITE, "9.9.9.9", BROWSER, "google")

        val snap = store.snapshot()
        assertEquals(43, snap.siteTotal)
        assertEquals(7, snap.resumeTotal)
        assertEquals(4, snap.today.site)
        assertEquals("20 Oct 2026", snap.sourcesSince)
        assertEquals(listOf(SourceView("google", 1, 0)), snap.sources)
    }

    @Test
    fun `sources survive a restart`() = runBlocking {
        val first = store()
        first.record(Target.SITE, "1.1.1.1", BROWSER, "linkedin.com", SITE_HOST)
        first.recordResumeLink("acme", "1.1.1.1", BROWSER)
        first.flush()

        val reopened = store()
        // The visitor's source today is persisted, so attribution survives a restart too.
        reopened.record(Target.RESUME, "1.1.1.1", BROWSER, SITE_HOST, SITE_HOST)
        val snap = reopened.snapshot()
        assertEquals(SourceView("linkedin.com", 1, 1), snap.sources.single())
        assertEquals(1, snap.links.single().opens)
    }
}
