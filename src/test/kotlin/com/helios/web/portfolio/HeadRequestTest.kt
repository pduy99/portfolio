package com.helios.web.portfolio

import com.helios.web.portfolio.stats.statsStore
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
import kotlin.io.path.createTempDirectory
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class HeadRequestTest {

    private val browserUserAgent =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36"

    private fun withApp(block: suspend ApplicationTestBuilder.(Application) -> Unit) = testApplication {
        val storage = createTempDirectory("head-test").toFile().apply { deleteOnExit() }
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
    fun `HEAD on the index answers like GET without a body`() = withApp {
        val get = client.get("/")
        val head = client.head("/")

        assertEquals(HttpStatusCode.OK, head.status)
        assertEquals(get.contentType()?.withoutParameters(), head.contentType()?.withoutParameters())
        assertTrue(head.bodyAsText().isEmpty(), "HEAD must not carry a body")
    }

    @Test
    fun `HEAD on a static resource answers 200`() = withApp {
        val path = "/static/" + (javaClass.classLoader.getResource("static")!!.file
            .let { java.io.File(it) }.walkTopDown().first { it.isFile }
            .relativeTo(java.io.File(javaClass.classLoader.getResource("static")!!.file)).invariantSeparatorsPath)

        assertEquals(HttpStatusCode.OK, client.get(path).status)
        assertEquals(HttpStatusCode.OK, client.head(path).status)
    }

    @Test
    fun `HEAD on an unknown path still answers 404`() = withApp {
        assertEquals(HttpStatusCode.NotFound, client.head("/does-not-exist").status)
    }

    @Test
    fun `HEAD is not counted as a visit but GET is`() = withApp { app ->
        client.head("/") {
            header(HttpHeaders.UserAgent, browserUserAgent)
            header("CF-Connecting-IP", "203.0.113.7")
        }
        assertEquals(0, app.statsStore.snapshot().siteTotal)

        client.get("/") {
            header(HttpHeaders.UserAgent, browserUserAgent)
            header("CF-Connecting-IP", "203.0.113.7")
        }
        assertEquals(1, app.statsStore.snapshot().siteTotal)
    }
}
