package com.helios.web.portfolio.routing

import com.helios.web.portfolio.stats.Target
import com.helios.web.portfolio.stats.recordResumeLink
import com.helios.web.portfolio.stats.recordVisit
import io.ktor.http.ContentDisposition
import io.ktor.http.HttpHeaders
import io.ktor.http.HttpStatusCode
import io.ktor.resources.Resource
import io.ktor.server.application.ApplicationCall
import io.ktor.server.request.header
import io.ktor.server.resources.get
import io.ktor.server.response.header
import io.ktor.server.response.respond
import io.ktor.server.response.respondFile
import io.ktor.server.routing.Route
import java.io.File

@Resource("/resume")
class Resume

/**
 * A tracked résumé link, such as /r/acme for an application to Acme. Any name matching
 * [RESUME_LINK_NAME] works without setting it up first; /stats lists who opened which.
 */
@Resource("/r/{name}")
class ResumeLink(val name: String)

val RESUME_LINK_NAME = Regex("^[a-z0-9][a-z0-9-]{0,39}$")

fun Route.resume() {
    get<Resume> {
        call.respondResume { call.recordVisit(Target.RESUME) }
    }

    get<ResumeLink> { link ->
        val name = link.name.lowercase()
        if (!RESUME_LINK_NAME.matches(name)) {
            call.respond(HttpStatusCode.NotFound)
            return@get
        }
        call.respondResume {
            call.recordResumeLink(name)
            call.recordVisit(Target.RESUME, source = "r/$name")
        }
    }
}

/** Serves the résumé PDF inline, running [record] only for the request that opens it. */
private suspend fun ApplicationCall.respondResume(record: suspend () -> Unit) {
    val cvDirectory = application.environment.config.property("storage.cv.directory").getString()
    val cvFile = File(cvDirectory, "DuyPham_CV.pdf")

    if (!cvFile.exists()) {
        throw IllegalStateException("Resume file not found at ${cvFile.absolutePath}")
    }

    // A single PDF view produces several requests once PartialContent starts
    // serving ranges, so only the opening request is counted.
    if (request.header(HttpHeaders.Range) == null) {
        record()
    }

    response.header(
        HttpHeaders.ContentDisposition,
        ContentDisposition.Inline.withParameter(
            ContentDisposition.Parameters.FileName,
            "DuyPham_CV.pdf"
        ).toString()
    )
    respondFile(cvFile)
}
