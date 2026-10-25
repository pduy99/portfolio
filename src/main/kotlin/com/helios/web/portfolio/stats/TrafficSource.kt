package com.helios.web.portfolio.stats

import java.net.URI

/** Source label for visitors who arrive with no referrer and no `ref` tag. */
const val DIRECT_SOURCE = "direct"

private val TAG = Regex("^[a-z0-9][a-z0-9._-]{0,39}$")

/** Hosts whose traffic is better known by another name: link shorteners, mobile and redirect hosts. */
private val ALIASES = mapOf(
    "lnkd.in" to "linkedin.com",
    "t.co" to "x.com",
    "twitter.com" to "x.com",
    "l.facebook.com" to "facebook.com",
    "lm.facebook.com" to "facebook.com",
    "m.facebook.com" to "facebook.com",
    "l.messenger.com" to "messenger.com",
    "out.reddit.com" to "reddit.com",
    "old.reddit.com" to "reddit.com",
    "news.ycombinator.com" to "hacker news",
    "com.linkedin.android" to "linkedin.com",
    "com.google.android.gm" to "gmail",
    "mail.google.com" to "gmail",
    "com.slack" to "slack",
    "app.slack.com" to "slack",
    "teams.microsoft.com" to "teams",
)

private val SEARCH_ENGINES = listOf("google", "bing", "duckduckgo", "yahoo", "yandex", "baidu", "ecosia", "coccoc")

/**
 * Names where a visitor came from.
 *
 * An explicit tag from a `?ref=` or `?utm_source=` query parameter wins, so links you share can
 * be told apart. Otherwise the referrer's host is used, normalised so that `www.`, mobile hosts,
 * link shorteners and country-specific search domains collapse into one name. Android apps that
 * open links send `android-app://<package>` referrers, which are mapped the same way.
 */
fun trafficSource(referer: String?, tag: String?): String {
    tag?.trim()?.lowercase()?.takeIf { TAG.matches(it) }?.let { return it }

    val host = referer?.trim()?.takeIf { it.isNotEmpty() }
        ?.let { runCatching { URI(it).host }.getOrNull() }
        ?.lowercase()
        ?.removePrefix("www.")
        ?: return DIRECT_SOURCE

    ALIASES[host]?.let { return it }
    val labels = host.split('.')
    SEARCH_ENGINES.firstOrNull { it in labels.dropLast(1) }?.let { return it }
    return host
}
