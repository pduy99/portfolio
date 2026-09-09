package com.helios.web.portfolio.stats

import com.helios.web.portfolio.module
import io.ktor.client.request.get
import io.ktor.http.HttpStatusCode
import io.ktor.server.config.MapApplicationConfig
import io.ktor.server.testing.testApplication
import kotlin.test.Test
import kotlin.test.assertEquals

class StatsRouteTest {

    /**
     * The test JVM has no STATS_PASSWORD, which is the same situation as a deploy where the
     * environment variable was never added. The page must refuse rather than open up.
     */
    @Test
    fun `stats refuses to serve when no password is configured`() = testApplication {
        if (StatsCredentials.configured) return@testApplication
        environment { config = MapApplicationConfig("storage.cv.directory" to ".") }
        application { module() }

        assertEquals(HttpStatusCode.ServiceUnavailable, client.get("/stats").status)
    }
}
