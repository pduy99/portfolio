package com.helios.web.portfolio.routing

import io.ktor.server.resources.get
import io.ktor.server.response.respondFile
import io.ktor.server.routing.Route
import java.io.File

fun Route.resume() {
    get<Resume> {
        call.respondFile(
            File("static/DuyPham_CV.pdf")
        )
    }
}