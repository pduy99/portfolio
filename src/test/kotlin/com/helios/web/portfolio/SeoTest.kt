package com.helios.web.portfolio

import io.ktor.client.request.get
import io.ktor.client.statement.bodyAsText
import io.ktor.client.statement.readRawBytes
import io.ktor.http.ContentType
import io.ktor.http.HttpStatusCode
import io.ktor.http.contentType
import io.ktor.server.config.MapApplicationConfig
import io.ktor.server.testing.ApplicationTestBuilder
import io.ktor.server.testing.testApplication
import kotlin.io.path.createTempDirectory
import kotlin.test.Test
import kotlin.test.assertContains
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class SeoTest {

    private fun withApp(
        vararg overrides: Pair<String, String>,
        block: suspend ApplicationTestBuilder.() -> Unit
    ) = testApplication {
        val storage = createTempDirectory("seo-test").toFile().apply { deleteOnExit() }
        environment {
            config = MapApplicationConfig("storage.cv.directory" to storage.absolutePath, *overrides)
        }
        application { module() }
        block()
    }

    @Test
    fun `index carries description, canonical and link preview tags`() = withApp {
        val html = client.get("/").bodyAsText()

        assertContains(html, """<meta name="description" content=""")
        assertContains(html, """<link rel="canonical" href="https://phpduy.dev/">""")
        assertContains(html, """<meta property="og:url" content="https://phpduy.dev/">""")
        assertContains(html, """<meta property="og:image" content="https://phpduy.dev/static/images/og-image.png">""")
        assertContains(html, """<meta name="twitter:card" content="summary_large_image">""")
        assertContains(html, """<link rel="icon" href="/favicon.ico" sizes="32x32">""")
    }

    @Test
    fun `pages load the compiled stylesheet instead of the Tailwind CDN`() = withApp {
        for (path in listOf("/", "/payment")) {
            assertFalse(client.get(path).bodyAsText().contains("cdn.tailwindcss.com"), "$path still uses the CDN")
        }
        assertTrue(
            Regex("""<link rel="stylesheet" href="/static/css/site\.css\?v=[0-9a-z]+">""")
                .containsMatchIn(client.get("/").bodyAsText())
        )
    }

    @Test
    fun `base URL is configurable`() = withApp("site.baseUrl" to "https://example.test/") {
        assertContains(client.get("/").bodyAsText(), """<link rel="canonical" href="https://example.test/">""")
        assertContains(client.get("/robots.txt").bodyAsText(), "Sitemap: https://example.test/sitemap.xml")
    }

    @Test
    fun `robots txt allows crawling, hides stats and points at the sitemap`() = withApp {
        val response = client.get("/robots.txt")

        assertEquals(HttpStatusCode.OK, response.status)
        assertEquals(ContentType.Text.Plain, response.contentType()?.withoutParameters())
        val body = response.bodyAsText()
        assertContains(body, "User-agent: *")
        assertContains(body, "Disallow: /stats")
        assertContains(body, "Sitemap: https://phpduy.dev/sitemap.xml")
    }

    @Test
    fun `sitemap lists the home page`() = withApp {
        val response = client.get("/sitemap.xml")

        assertEquals(HttpStatusCode.OK, response.status)
        assertEquals(ContentType.Application.Xml, response.contentType()?.withoutParameters())
        assertContains(response.bodyAsText(), "<loc>https://phpduy.dev/</loc>")
    }

    @Test
    fun `root icons are served`() = withApp {
        val ico = client.get("/favicon.ico")
        assertEquals(HttpStatusCode.OK, ico.status)
        // ICO header: reserved 0, type 1 (icon).
        assertEquals(listOf<Byte>(0, 0, 1, 0), ico.readRawBytes().take(4))

        val touch = client.get("/apple-touch-icon.png")
        assertEquals(HttpStatusCode.OK, touch.status)
        assertEquals(ContentType.Image.PNG, touch.contentType())
    }
}
