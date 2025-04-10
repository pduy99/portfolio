package com.helios.web.portfolio.routing

import io.ktor.http.ContentDisposition
import io.ktor.http.ContentType
import io.ktor.http.HttpHeaders
import io.ktor.server.resources.get
import io.ktor.server.response.header
import io.ktor.server.response.respondOutputStream
import io.ktor.server.routing.Route

fun Route.resume() {
    get<Resume> {
        val inputStream = this::class.java.classLoader.getResourceAsStream("static/DuyPham_CV.pdf")
            ?: throw IllegalStateException("Resume file not found")

        call.response.header(
            HttpHeaders.ContentDisposition,
            ContentDisposition.Inline.withParameter(
                ContentDisposition.Parameters.FileName,
                "DuyPham_CV.pdf"
            ).toString()
        )
        call.respondOutputStream(ContentType.Application.Pdf) {
            inputStream.copyTo(this)
        }
    }
}