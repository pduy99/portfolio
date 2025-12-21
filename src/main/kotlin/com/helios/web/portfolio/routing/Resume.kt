package com.helios.web.portfolio.routing

import io.ktor.http.ContentDisposition
import io.ktor.http.HttpHeaders
import io.ktor.resources.Resource
import io.ktor.server.application.call
import io.ktor.server.resources.get
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