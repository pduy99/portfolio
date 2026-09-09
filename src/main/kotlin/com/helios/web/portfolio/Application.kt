package com.helios.web.portfolio

import com.helios.web.portfolio.routing.STATS_AUTH
import com.helios.web.portfolio.routing.configureRouting
import com.helios.web.portfolio.stats.StatsCredentials
import com.helios.web.portfolio.stats.StatsKey
import com.helios.web.portfolio.stats.StatsStore
import freemarker.cache.ClassTemplateLoader
import io.ktor.server.application.Application
import io.ktor.server.application.install
import io.ktor.server.application.log
import io.ktor.server.application.ApplicationStopping
import io.ktor.server.auth.Authentication
import io.ktor.server.auth.UserIdPrincipal
import io.ktor.server.auth.basic
import io.ktor.server.freemarker.FreeMarker
import io.ktor.server.netty.EngineMain
import io.ktor.server.plugins.calllogging.CallLogging
import io.ktor.server.plugins.conditionalheaders.ConditionalHeaders
import io.ktor.server.plugins.defaultheaders.DefaultHeaders
import io.ktor.server.plugins.partialcontent.PartialContent
import io.ktor.server.resources.Resources
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import java.io.File
import java.security.MessageDigest

fun main(args: Array<String>) {
    EngineMain.main(args)
}

fun Application.module() {
    // This adds the Date and Server headers to each response and would allow you to configure
    // additional headers served to each response.
    install(DefaultHeaders)
    // This uses the logger to log every call (request/response)
    install(CallLogging)
    // Automatic '304 Not Modified' Responses
    install(ConditionalHeaders)
    // Supports for Range, Accept-Range and Content-Range headers
    install(PartialContent)
    // Allows using classes annotated with @Resource to represent URLs.
    // They are typed, can be constructed to generate URLs, and can be used to register routes.
    install(Resources)
    // Adds support to generate templated responses using FreeMarker.
    // We configure it specifying the path inside the resources to use to get the template files.
    // You can use <!-- @ftlvariable --> to annotate types inside the templates
    // in a way that works with IntelliJ IDEA Ultimate.
    // You can check the `resources/templates/*.ftl` files for reference.
    install(FreeMarker) {
        templateLoader = ClassTemplateLoader(this::class.java.classLoader, "templates")
    }

    configureStats()

    configureRouting()
}

/**
 * Visit counting. Requests only touch memory; the store is flushed on a timer and on
 * shutdown, so a container recreate costs at most one interval of counts.
 */
private fun Application.configureStats() {
    val cvDirectory = environment.config.property("storage.cv.directory").getString()
    val store = StatsStore(File(cvDirectory, "stats.json"))
    attributes.put(StatsKey, store)

    val password = StatsCredentials.password
    if (password == null) {
        log.warn("STATS_PASSWORD is not set - /stats will refuse to serve.")
    } else {
        install(Authentication) {
            basic(STATS_AUTH) {
                realm = "Portfolio stats"
                validate { credentials ->
                    val userMatches = constantTimeEquals(credentials.name, StatsCredentials.user)
                    val passwordMatches = constantTimeEquals(credentials.password, password)
                    if (userMatches && passwordMatches) UserIdPrincipal(credentials.name) else null
                }
            }
        }
    }

    launch {
        while (isActive) {
            delay(FLUSH_INTERVAL_MS)
            store.flush()
        }
    }
    monitor.subscribe(ApplicationStopping) {
        runBlocking { store.flush() }
    }
}

private const val FLUSH_INTERVAL_MS = 60_000L

/** Comparison that does not leak the position of the first differing character. */
private fun constantTimeEquals(a: String, b: String): Boolean =
    MessageDigest.isEqual(a.toByteArray(), b.toByteArray())