package com.helios.web.portfolio.stats

import io.ktor.http.HttpHeaders
import io.ktor.http.HttpMethod
import io.ktor.server.application.Application
import io.ktor.server.application.ApplicationCall
import io.ktor.server.request.header
import io.ktor.util.AttributeKey

val StatsKey = AttributeKey<StatsStore>("StatsStore")

val Application.statsStore: StatsStore get() = attributes[StatsKey]

/**
 * The real visitor address. cloudflared runs on the host and proxies to this container, so
 * [io.ktor.server.plugins.origin] only ever reports the tunnel; the client address arrives
 * in a header.
 */
fun ApplicationCall.clientIp(): String? =
    request.header("CF-Connecting-IP")
        ?: request.header("X-Forwarded-For")?.substringBefore(',')?.trim()?.takeIf { it.isNotBlank() }


/**
 * Counts this request as a view of [target]. HEAD requests are skipped: AutoHeadResponse
 * answers them by running the GET handler, but a HEAD never renders a page for a person.
 * The plugin rewrites the routed method to GET, so the original method is read from
 * [io.ktor.server.request.ApplicationRequest.local].
 */
suspend fun ApplicationCall.recordVisit(target: Target) {
    if (request.local.method == HttpMethod.Head) return
    application.statsStore.record(target, clientIp(), request.header(HttpHeaders.UserAgent))
}
