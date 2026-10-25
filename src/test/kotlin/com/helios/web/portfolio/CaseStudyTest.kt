package com.helios.web.portfolio

import com.helios.web.portfolio.routing.CaseStudies
import io.ktor.client.request.get
import io.ktor.client.request.head
import io.ktor.client.statement.bodyAsText
import io.ktor.http.HttpStatusCode
import io.ktor.server.config.MapApplicationConfig
import io.ktor.server.testing.ApplicationTestBuilder
import io.ktor.server.testing.testApplication
import java.io.File
import kotlin.io.path.createTempDirectory
import kotlin.test.Test
import kotlin.test.assertContains
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNotNull

class CaseStudyTest {

    private fun withApp(portfolioConfig: String? = null, block: suspend ApplicationTestBuilder.() -> Unit) = testApplication {
        val storage = createTempDirectory("case-study-test").toFile().apply { deleteOnExit() }
        if (portfolioConfig != null) File(storage, "portfolio-config.json").writeText(portfolioConfig)
        environment { config = MapApplicationConfig("storage.cv.directory" to storage.absolutePath) }
        application { module() }
        block()
    }

    @Test
    fun `every registered case study renders with its own metadata`() = withApp {
        for (study in CaseStudies.all) {
            val response = client.get(study.path)
            assertEquals(HttpStatusCode.OK, response.status, study.path)
            val html = response.bodyAsText()
            assertContains(html, """<link rel="canonical" href="https://phpduy.dev${study.path}">""")
            assertContains(html, """<meta property="og:image" content="https://phpduy.dev${study.previewImage}">""")
            assertContains(html, "<title>${study.title} case study - Duy Pham</title>")
        }
    }

    @Test
    fun `case study assets exist`() {
        for (study in CaseStudies.all) {
            assertNotNull(javaClass.classLoader.getResource(study.previewImage.removePrefix("/")), study.previewImage)
            assertNotNull(javaClass.classLoader.getResource("templates/${study.template}"), study.template)
        }
        for (asset in listOf("demo-landscape.mp4", "demo-portrait.mp4", "demo-landscape.jpg", "demo-portrait.jpg", "app-icon.png")) {
            assertNotNull(javaClass.classLoader.getResource("static/media/case-studies/shot-clock/$asset"), asset)
        }
    }

    @Test
    fun `shot clock page has its sections, video and table of contents`() = withApp {
        val html = client.get("/projects/shot-clock").bodyAsText()
        for (id in listOf("problem", "experience", "architecture", "detection", "survival", "deletion", "shipping", "outcome")) {
            assertContains(html, """<section id="$id"""")
            assertContains(html, """href="#$id"""")
        }
        assertContains(html, """data-portrait="/static/media/case-studies/shot-clock/demo-portrait.mp4"""")
        assertContains(html, """src="/static/js/case-study.js"""")
    }

    @Test
    fun `unknown case studies are not found`() = withApp {
        assertEquals(HttpStatusCode.NotFound, client.get("/projects/nope").status)
        assertEquals(HttpStatusCode.NotFound, client.head("/projects/nope").status)
    }

    @Test
    fun `case studies are in the sitemap`() = withApp {
        assertContains(client.get("/sitemap.xml").bodyAsText(), "<loc>https://phpduy.dev/projects/shot-clock</loc>")
    }

    @Test
    fun `a project links to its case study only when the slug exists`() = withApp(
        portfolioConfig = """
        {
          "profile": { "name": "Duy Pham", "title": "Senior Android Engineer", "about": "About.", "social": [] },
          "content": {
            "about": { "paragraphs": ["Hi."] },
            "experience": [],
            "projects": [
              { "name": "Shot Clock", "url": "https://play.google.com/store/apps/details?id=com.helios.shotclock",
                "imageUrl": null, "description": "Screenshots with an expiry date.", "technologies": [], "caseStudy": "shot-clock" },
              { "name": "Typo", "url": "https://example.com", "imageUrl": null, "description": "Has a bad slug.",
                "technologies": [], "caseStudy": "does-not-exist" }
            ]
          }
        }
        """.trimIndent()
    ) {
        val html = client.get("/").bodyAsText()
        assertContains(html, """href="/projects/shot-clock"""")
        assertFalse(html.contains("/projects/does-not-exist"))
    }
}
