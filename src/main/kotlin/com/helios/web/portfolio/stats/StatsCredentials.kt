package com.helios.web.portfolio.stats

/**
 * Credentials for /stats, read from the environment.
 *
 * Deliberately fails closed: with no password set the route refuses to serve rather than
 * falling back to an open or empty-password page.
 */
object StatsCredentials {
    val user: String = System.getenv("STATS_USER")?.takeIf { it.isNotBlank() } ?: "admin"
    val password: String? = System.getenv("STATS_PASSWORD")?.takeIf { it.isNotBlank() }
    val configured: Boolean get() = password != null
}
