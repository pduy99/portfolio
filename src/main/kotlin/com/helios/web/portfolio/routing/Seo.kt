package com.helios.web.portfolio.routing

import com.helios.web.portfolio.Site
import io.ktor.http.ContentType
import io.ktor.http.HttpStatusCode
import io.ktor.server.http.content.resolveResource
import io.ktor.server.response.respond
import io.ktor.server.response.respondText
import io.ktor.server.routing.Route
import io.ktor.server.routing.get

/**
 * Files that crawlers and browsers look for at the site root: robots.txt, sitemap.xml and the
 * icons requested without a <link> tag (`/favicon.ico`, `/apple-touch-icon.png`).
 */
fun Route.seo(site: Site) {
    get("/robots.txt") {
        call.respondText(
            """
            |User-agent: *
            |Disallow: /stats
            |Disallow: /r/
            |
            |Sitemap: ${site.baseUrl}/sitemap.xml
            |""".trimMargin(),
            ContentType.Text.Plain
        )
    }

    get("/sitemap.xml") {
        call.respondText(
            """
            |<?xml version="1.0" encoding="UTF-8"?>
            |<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
            |  <url><loc>${site.baseUrl}/</loc></url>
            |${CaseStudies.all.joinToString("") { "  <url><loc>${site.baseUrl}${it.path}</loc></url>\n" }}            |</urlset>
            |""".trimMargin(),
            ContentType.Application.Xml
        )
    }

    for (icon in listOf("favicon.ico", "apple-touch-icon.png")) {
        get("/$icon") {
            val content = call.resolveResource("static/images/icons/$icon")
            if (content == null) call.respond(HttpStatusCode.NotFound) else call.respond(content)
        }
    }
}
