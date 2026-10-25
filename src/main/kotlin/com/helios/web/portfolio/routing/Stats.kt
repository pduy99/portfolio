package com.helios.web.portfolio.routing

import com.helios.web.portfolio.stats.StatsCredentials
import com.helios.web.portfolio.stats.StatsView
import com.helios.web.portfolio.stats.statsStore
import io.ktor.http.ContentType
import io.ktor.http.HttpStatusCode
import io.ktor.resources.Resource
import io.ktor.server.auth.authenticate
import io.ktor.server.freemarker.FreeMarkerContent
import io.ktor.server.resources.get
import io.ktor.server.response.respond
import io.ktor.server.response.respondText
import io.ktor.server.routing.Route
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

@Resource("/stats")
class Stats

/** The /stats numbers as JSON, for scripts such as the weekly summary email. */
@Resource("/stats.json")
class StatsJson

private val statsJson = Json { encodeDefaults = true }

fun Route.stats() {
    if (!StatsCredentials.configured) {
        get<Stats> {
            call.respond(HttpStatusCode.ServiceUnavailable, "Stats are not configured.")
        }
        get<StatsJson> {
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
        get<StatsJson> {
            val snapshot = call.application.statsStore.snapshot()
            call.respondText(statsJson.encodeToString<StatsView>(snapshot), ContentType.Application.Json)
        }
    }
}

const val STATS_AUTH = "stats-basic"
