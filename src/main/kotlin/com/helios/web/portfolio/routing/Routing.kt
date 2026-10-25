package com.helios.web.portfolio.routing

import com.helios.web.portfolio.Site
import io.ktor.resources.Resource
import io.ktor.server.application.Application
import io.ktor.server.http.content.staticResources
import io.ktor.server.routing.routing

@Resource("/")
class Index

fun Application.configureRouting(site: Site) {
    routing {
        index()
        resume()
        payment()
        stats()
        seo(site)
        staticResources("/static", "static")
    }
}