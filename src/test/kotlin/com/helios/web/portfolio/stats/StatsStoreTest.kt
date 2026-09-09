package com.helios.web.portfolio.stats

import kotlinx.coroutines.runBlocking
import java.io.File
import java.nio.file.Files
import kotlin.test.AfterTest
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

private const val BROWSER =
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36"

class StatsStoreTest {

    private val dir: File = Files.createTempDirectory("stats-test").toFile()
    private fun store() = StatsStore(File(dir, "stats.json"))

    @AfterTest
    fun cleanup() {
        dir.deleteRecursively()
    }

    @Test
    fun `counts a real visitor`() = runBlocking {
        val store = store()
        assertTrue(store.record(Target.SITE, "1.2.3.4", BROWSER))
        assertEquals(1, store.snapshot().siteTotal)
    }

    @Test
    fun `ignores crawlers`() = runBlocking {
        val store = store()
        listOf(
            "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
            "Mozilla/5.0 (compatible; bingbot/2.0)",
            "curl/8.4.0",
            "python-requests/2.31.0",
            "facebookexternalhit/1.1"
        ).forEachIndexed { i, agent ->
            assertFalse(store.record(Target.SITE, "9.9.9.$i", agent), "should ignore: $agent")
        }
        assertEquals(0, store.snapshot().siteTotal)
    }

    @Test
    fun `ignores requests with no user agent`() = runBlocking {
        assertFalse(store().record(Target.SITE, "1.2.3.4", null))
    }

    @Test
    fun `counts each visitor once per day`() = runBlocking {
        val store = store()
        assertTrue(store.record(Target.SITE, "1.2.3.4", BROWSER))
        assertFalse(store.record(Target.SITE, "1.2.3.4", BROWSER))
        assertFalse(store.record(Target.SITE, "1.2.3.4", BROWSER))
        assertEquals(1, store.snapshot().siteTotal)
    }

    @Test
    fun `counts distinct visitors separately`() = runBlocking {
        val store = store()
        store.record(Target.SITE, "1.2.3.4", BROWSER)
        store.record(Target.SITE, "5.6.7.8", BROWSER)
        assertEquals(2, store.snapshot().siteTotal)
    }

    @Test
    fun `site and resume are counted independently`() = runBlocking {
        val store = store()
        store.record(Target.SITE, "1.2.3.4", BROWSER)
        assertTrue(store.record(Target.RESUME, "1.2.3.4", BROWSER), "same visitor may do both")
        val snap = store.snapshot()
        assertEquals(1, snap.siteTotal)
        assertEquals(1, snap.resumeTotal)
    }

    @Test
    fun `survives a restart`() = runBlocking {
        val first = store()
        first.record(Target.SITE, "1.2.3.4", BROWSER)
        first.record(Target.RESUME, "1.2.3.4", BROWSER)
        first.flush()

        val reopened = store()
        val snap = reopened.snapshot()
        assertEquals(1, snap.siteTotal)
        assertEquals(1, snap.resumeTotal)
        // The de-duplication set is persisted too, so a restart cannot double count.
        assertFalse(reopened.record(Target.SITE, "1.2.3.4", BROWSER))
    }

    @Test
    fun `starts clean when the file is corrupt rather than throwing`() = runBlocking {
        File(dir, "stats.json").writeText("{ this is not json")
        val store = store()
        assertEquals(0, store.snapshot().siteTotal)
        assertTrue(store.record(Target.SITE, "1.2.3.4", BROWSER))
    }

    @Test
    fun `reports the share of visitors who open the cv`() = runBlocking {
        val store = store()
        repeat(4) { store.record(Target.SITE, "1.2.3.$it", BROWSER) }
        store.record(Target.RESUME, "1.2.3.0", BROWSER)
        assertEquals(25, store.snapshot().conversion)
    }

    @Test
    fun `snapshot always returns a full window`() = runBlocking {
        assertEquals(30, store().snapshot(30).days.size)
    }
}
