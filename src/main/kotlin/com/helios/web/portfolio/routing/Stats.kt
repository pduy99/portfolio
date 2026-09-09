package com.helios.web.portfolio.routing

import com.helios.web.portfolio.stats.StatsCredentials
import com.helios.web.portfolio.stats.statsStore
import io.ktor.http.HttpStatusCode
import io.ktor.resources.Resource
import io.ktor.server.auth.authenticate
import io.ktor.server.freemarker.FreeMarkerContent
import io.ktor.server.resources.get
import io.ktor.server.response.respond
import io.ktor.server.routing.Route

@Resource("/stats")
class Stats

fun Route.stats() {
    if (!StatsCredentials.configured) {
        get<Stats> {
            call.respond(HttpStatusCode.ServiceUnavailable, "Stats are not configured.")
        }
        return
    }

    authenticate(STATS_AUTH) {
        get<Stats> {
            call.respond(
                FreeMarkerContent("stats.ftl", mapOf("stats" to call.application.statsStore.snapshot()))
            )
        }
    }
}

const val STATS_AUTH = "stats-basic"
