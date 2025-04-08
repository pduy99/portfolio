package com.helios.web.portfolio.routing

import io.ktor.resources.Resource
import io.ktor.server.application.Application
import io.ktor.server.http.content.staticResources
import io.ktor.server.routing.routing

@Resource("/")
class Index

@Resource("/resume")
class Resume

fun Application.configureRouting() {
    routing {
        index()
        resume()
        staticResources("/static", "static")
    }
}