package com.helios.web.portfolio.stats

import kotlin.test.Test
import kotlin.test.assertEquals

class TrafficSourceTest {

    @Test
    fun `no referrer and no tag is direct`() {
        assertEquals(DIRECT_SOURCE, trafficSource(null, null))
        assertEquals(DIRECT_SOURCE, trafficSource("", null))
        assertEquals(DIRECT_SOURCE, trafficSource("not a url", null))
    }

    @Test
    fun `a valid tag wins over the referrer`() {
        assertEquals("newsletter", trafficSource("https://www.google.com/", "Newsletter"))
    }

    @Test
    fun `an invalid tag is ignored`() {
        assertEquals("google", trafficSource("https://www.google.com/", "<script>"))
        assertEquals("google", trafficSource("https://www.google.com/", "x".repeat(41)))
    }

    @Test
    fun `hosts are normalised`() {
        assertEquals("github.com", trafficSource("https://www.github.com/pduy99", null))
        assertEquals("linkedin.com", trafficSource("https://lnkd.in/abc", null))
        assertEquals("linkedin.com", trafficSource("android-app://com.linkedin.android/", null))
        assertEquals("x.com", trafficSource("https://t.co/xyz", null))
        assertEquals("facebook.com", trafficSource("https://l.facebook.com/", null))
        assertEquals("gmail", trafficSource("https://mail.google.com/", null))
    }

    @Test
    fun `country search domains collapse into the engine`() {
        assertEquals("google", trafficSource("https://www.google.com.vn/", null))
        assertEquals("google", trafficSource("https://google.co.uk/", null))
        assertEquals("bing", trafficSource("https://www.bing.com/search?q=duy", null))
        assertEquals("coccoc", trafficSource("https://coccoc.com/search", null))
    }

    @Test
    fun `a domain that merely contains an engine name is not that engine`() {
        assertEquals("notgoogle.dev", trafficSource("https://notgoogle.dev/", null))
    }
}
