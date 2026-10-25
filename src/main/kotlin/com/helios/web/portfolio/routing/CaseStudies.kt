package com.helios.web.portfolio.routing

import io.ktor.http.HttpStatusCode
import io.ktor.resources.Resource
import io.ktor.server.freemarker.FreeMarkerContent
import io.ktor.server.resources.get
import io.ktor.server.response.respond
import io.ktor.server.routing.Route

/** A long-form write-up of one project, served at /projects/<slug>. */
data class CaseStudy(
    val slug: String,
    /** FreeMarker template under templates/case-studies/. */
    val template: String,
    val title: String,
    /** One sentence for the meta description and link previews. */
    val summary: String,
    /** 1200x630 image for link previews, relative to the site root. */
    val previewImage: String,
) {
    val path: String get() = "/projects/$slug"
}

object CaseStudies {
    val all: List<CaseStudy> = listOf(
        CaseStudy(
            slug = "shot-clock",
            template = "case-studies/shot-clock.ftl",
            title = "Shot Clock",
            summary = "How I built and shipped an Android app that asks how long each screenshot should live, " +
                "then deletes it on time: staying alive under Android's background limits, deleting files " +
                "without a prompt each time, and releasing through a fully automated Play pipeline.",
            previewImage = "/static/media/case-studies/shot-clock/preview.jpg",
        ),
    )

    private val bySlug = all.associateBy { it.slug }

    fun find(slug: String): CaseStudy? = bySlug[slug]
}

@Resource("/projects/{slug}")
class CaseStudyPage(val slug: String)

fun Route.caseStudies() {
    get<CaseStudyPage> { page ->
        val study = CaseStudies.find(page.slug)
        if (study == null) {
            call.respond(HttpStatusCode.NotFound)
            return@get
        }
        call.respond(FreeMarkerContent(study.template, mapOf("study" to study)))
    }
}
