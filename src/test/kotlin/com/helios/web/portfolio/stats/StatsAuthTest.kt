package com.helios.web.portfolio.stats

import com.helios.web.portfolio.module
import io.ktor.client.plugins.auth.Auth
import io.ktor.client.plugins.auth.providers.BasicAuthCredentials
import io.ktor.client.plugins.auth.providers.basic
import io.ktor.client.request.get
import io.ktor.client.statement.bodyAsText
import io.ktor.http.HttpStatusCode
import io.ktor.server.config.MapApplicationConfig
import io.ktor.server.testing.testApplication
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

/**
 * Only meaningful with a password in the environment; see the `tasks.test` block in
 * build.gradle.kts. Run with: STATS_PASSWORD=secret ./gradlew test
 */
class StatsAuthTest {

    private val configured = StatsCredentials.configured

    @Test
    fun `rejects a request with no credentials`() = testApplication {
        if (!configured) return@testApplication
        environment { config = MapApplicationConfig("storage.cv.directory" to ".") }
        application { module() }

        assertEquals(HttpStatusCode.Unauthorized, client.get("/stats").status)
    }

    @Test
    fun `rejects a wrong password`() = testApplication {
        if (!configured) return@testApplication
        environment { config = MapApplicationConfig("storage.cv.directory" to ".") }
        application { module() }

        val client = createClient {
            install(Auth) { basic { credentials { BasicAuthCredentials(StatsCredentials.user, "wrong") } } }
        }
        assertEquals(HttpStatusCode.Unauthorized, client.get("/stats").status)
    }

    @Test
    fun `serves the dashboard with correct credentials`() = testApplication {
        if (!configured) return@testApplication
        environment { config = MapApplicationConfig("storage.cv.directory" to ".") }
        application { module() }

        val client = createClient {
            install(Auth) {
                basic {
                    sendWithoutRequest { true }
                    credentials { BasicAuthCredentials(StatsCredentials.user, StatsCredentials.password!!) }
                }
            }
        }
        val response = client.get("/stats")
        assertEquals(HttpStatusCode.OK, response.status)
        val body = response.bodyAsText()
        assertTrue(body.contains("Visitors"), "should render the dashboard")
        assertTrue(body.contains("noindex"), "must not be indexable")
    }
}
