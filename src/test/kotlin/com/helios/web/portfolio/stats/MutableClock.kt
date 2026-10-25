package com.helios.web.portfolio.stats

import java.time.Clock
import java.time.Duration
import java.time.Instant
import java.time.LocalDateTime
import java.time.ZoneId

/** A clock tests can move forward. */
class MutableClock(start: LocalDateTime, private val zone: ZoneId = STATS_ZONE) : Clock() {
    private var now: Instant = start.atZone(zone).toInstant()

    fun advance(duration: Duration) {
        now = now.plus(duration)
    }

    override fun getZone(): ZoneId = zone
    override fun withZone(zone: ZoneId): Clock = this
    override fun instant(): Instant = now
}
