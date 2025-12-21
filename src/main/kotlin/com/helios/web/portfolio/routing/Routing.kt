package com.helios.web.portfolio.routing

import io.ktor.resources.Resource
import io.ktor.server.application.Application
import io.ktor.server.http.content.staticResources
import io.ktor.server.routing.routing

@Resource("/")
class Index

fun Application.configureRouting() {
    routing {
        index()
        resume()
        payment()
        staticResources("/static", "static")
    }
}