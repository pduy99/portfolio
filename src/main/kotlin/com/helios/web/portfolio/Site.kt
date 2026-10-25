package com.helios.web.portfolio

import io.ktor.server.application.Application
import io.ktor.server.application.log
import io.ktor.util.AttributeKey
import java.net.URI
import java.security.MessageDigest

/** Public facts about the deployed site that templates and routes share. */
data class Site(
    /** Origin used for canonical links, Open Graph URLs and the sitemap. No trailing slash. */
    val baseUrl: String,
    /**
     * Short hash of the compiled stylesheet. It goes into the stylesheet URL so Cloudflare and
     * browsers fetch the new file after every deploy that changes it.
     */
    val cssVersion: String,
) {
    /** Host part of [baseUrl], used to recognise the site as its own referrer. */
    val host: String get() = URI(baseUrl).host
}

val SiteKey = AttributeKey<Site>("Site")

private const val DEFAULT_BASE_URL = "https://phpduy.dev"
private const val STYLESHEET = "static/css/site.css"

fun Application.loadSite(): Site {
    val baseUrl = (environment.config.propertyOrNull("site.baseUrl")?.getString() ?: DEFAULT_BASE_URL)
        .trimEnd('/')

    val css = Site::class.java.classLoader.getResourceAsStream(STYLESHEET)?.use { it.readBytes() }
    val cssVersion = if (css == null) {
        log.warn("$STYLESHEET is missing. Run `npm run build:css`; pages will render unstyled.")
        "missing"
    } else {
        MessageDigest.getInstance("SHA-256").digest(css).take(6).joinToString("") { "%02x".format(it) }
    }
    return Site(baseUrl, cssVersion)
}
