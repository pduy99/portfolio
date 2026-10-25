package com.helios.web.portfolio

import com.helios.web.portfolio.stats.SourceView
import com.helios.web.portfolio.stats.StatsCredentials
import com.helios.web.portfolio.stats.statsStore
import io.ktor.client.plugins.auth.Auth
import io.ktor.client.plugins.auth.providers.BasicAuthCredentials
import io.ktor.client.plugins.auth.providers.basic
import io.ktor.client.request.get
import io.ktor.client.request.head
import io.ktor.client.request.header
import io.ktor.client.statement.bodyAsText
import io.ktor.http.ContentType
import io.ktor.http.HttpHeaders
import io.ktor.http.HttpStatusCode
import io.ktor.http.contentType
import io.ktor.server.application.Application
import io.ktor.server.config.MapApplicationConfig
import io.ktor.server.testing.ApplicationTestBuilder
import io.ktor.server.testing.testApplication
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlinx.serialization.json.long
import java.io.File
import kotlin.io.path.createTempDirectory
import kotlin.test.Test
import kotlin.test.assertContains
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class ResumeLinkRouteTest {

    private val browser =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36"

    private fun withApp(block: suspend ApplicationTestBuilder.(Application) -> Unit) = testApplication {
        val storage = createTempDirectory("resume-link-test").toFile().apply { deleteOnExit() }
        File(storage, "DuyPham_CV.pdf").writeBytes("%PDF-1.4 test".toByteArray())
        environment { config = MapApplicationConfig("storage.cv.directory" to storage.absolutePath) }
        lateinit var app: Application
        application {
            module()
            app = this
        }
        startApplication()
        block(app)
    }

    @Test
    fun `a tracked link serves the resume and records the open`() = withApp { app ->
        val response = client.get("/r/Acme") {
            header(HttpHeaders.UserAgent, browser)
            header("CF-Connecting-IP", "203.0.113.7")
        }

        assertEquals(HttpStatusCode.OK, response.status)
        assertEquals(ContentType.Application.Pdf, response.contentType())
        assertContains(response.headers[HttpHeaders.ContentDisposition].orEmpty(), "DuyPham_CV.pdf")

        val snap = app.statsStore.snapshot()
        assertEquals("acme", snap.links.single().name)
        assertEquals(1, snap.links.single().opens)
        assertEquals(1, snap.resumeTotal)
        assertEquals(listOf(SourceView("r/acme", 0, 1)), snap.sources)
    }

    @Test
    fun `an invalid link name is not found and records nothing`() = withApp { app ->
        for (path in listOf("/r/bad_name", "/r/-dash-first", "/r/" + "a".repeat(41))) {
            val response = client.get(path) { header(HttpHeaders.UserAgent, browser); header("CF-Connecting-IP", "203.0.113.7") }
            assertEquals(HttpStatusCode.NotFound, response.status, path)
        }
        assertTrue(app.statsStore.snapshot().links.isEmpty())
    }

    @Test
    fun `HEAD on a tracked link is answered but not recorded`() = withApp { app ->
        val response = client.head("/r/acme") { header(HttpHeaders.UserAgent, browser); header("CF-Connecting-IP", "203.0.113.7") }

        assertEquals(HttpStatusCode.OK, response.status)
        assertTrue(app.statsStore.snapshot().links.isEmpty())
    }

    @Test
    fun `the site visit records where the visitor came from`() = withApp { app ->
        client.get("/") {
            header(HttpHeaders.UserAgent, browser)
            header("CF-Connecting-IP", "203.0.113.7")
            header(HttpHeaders.Referrer, "https://www.linkedin.com/")
        }
        client.get("/resume") {
            header(HttpHeaders.UserAgent, browser)
            header("CF-Connecting-IP", "203.0.113.7")
            header(HttpHeaders.Referrer, "https://phpduy.dev/")
        }
        client.get("/?ref=newsletter") {
            header(HttpHeaders.UserAgent, browser)
            header("CF-Connecting-IP", "198.51.100.1")
        }

        val sources = app.statsStore.snapshot().sources
        assertEquals(SourceView("linkedin.com", 1, 1), sources.single { it.name == "linkedin.com" })
        assertEquals(SourceView("newsletter", 1, 0), sources.single { it.name == "newsletter" })
    }

    @Test
    fun `robots txt keeps crawlers off tracked links`() = withApp {
        assertContains(client.get("/robots.txt").bodyAsText(), "Disallow: /r/")
    }

    @Test
    fun `stats json is refused without credentials`() = withApp {
        val expected = if (StatsCredentials.configured) HttpStatusCode.Unauthorized else HttpStatusCode.ServiceUnavailable
        assertEquals(expected, client.get("/stats.json").status)
    }

    /** Only runs with a password in the environment: STATS_PASSWORD=secret ./gradlew test */
    @Test
    fun `stats json and the dashboard show sources and links`() = withApp {
        if (!StatsCredentials.configured) return@withApp
        client.get("/r/acme") { header(HttpHeaders.UserAgent, browser); header("CF-Connecting-IP", "203.0.113.7") }

        val authed = createClient {
            install(Auth) {
                basic {
                    sendWithoutRequest { true }
                    credentials { BasicAuthCredentials(StatsCredentials.user, StatsCredentials.password!!) }
                }
            }
        }
        val json = authed.get("/stats.json")
        assertEquals(ContentType.Application.Json, json.contentType()?.withoutParameters())
        val body = Json.parseToJsonElement(json.bodyAsText()).jsonObject
        assertEquals(1, body["resumeTotal"]!!.jsonPrimitive.long)
        assertEquals("acme", body["links"]!!.jsonArray.single().jsonObject["name"]!!.jsonPrimitive.content)
        assertEquals(1, body["week"]!!.jsonObject["resume"]!!.jsonPrimitive.long)

        val html = authed.get("/stats").bodyAsText()
        assertContains(html, "Where visitors come from")
        assertContains(html, "/r/acme")
    }
}
