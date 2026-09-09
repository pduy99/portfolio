package com.helios.web.portfolio.stats

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
