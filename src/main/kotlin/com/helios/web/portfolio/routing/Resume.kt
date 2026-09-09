package com.helios.web.portfolio.routing

import com.helios.web.portfolio.stats.Target
import com.helios.web.portfolio.stats.clientIp
import com.helios.web.portfolio.stats.statsStore
import io.ktor.http.ContentDisposition
import io.ktor.http.HttpHeaders
import io.ktor.resources.Resource
import io.ktor.server.application.call
import io.ktor.server.resources.get
import io.ktor.server.request.header
import io.ktor.server.response.header
import io.ktor.server.response.respondFile
import io.ktor.server.routing.Route
import java.io.File

@Resource("/resume")
class Resume

fun Route.resume() {
    get<Resume> {
        val config = environment.config
        val cvDirectory = config.property("storage.cv.directory").getString()
        val cvFile = File(cvDirectory, "DuyPham_CV.pdf")

        if (!cvFile.exists()) {
            throw IllegalStateException("Resume file not found at ${cvFile.absolutePath}")
        }

        // A single PDF view produces several requests once PartialContent starts
        // serving ranges, so only the opening request is counted.
        if (call.request.header(HttpHeaders.Range) == null) {
            call.application.statsStore.record(
                Target.RESUME, call.clientIp(), call.request.header(HttpHeaders.UserAgent)
            )
        }

        call.response.header(
            HttpHeaders.ContentDisposition,
            ContentDisposition.Inline.withParameter(
                ContentDisposition.Parameters.FileName,
                "DuyPham_CV.pdf"
            ).toString()
        )
        call.respondFile(cvFile)
    }
}