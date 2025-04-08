package com.helios.web.portfolio.routing

import com.helios.web.portfolio.data.DataProvider
import io.ktor.server.freemarker.*
import io.ktor.server.resources.*
import io.ktor.server.response.respond
import io.ktor.server.routing.*

fun Route.index() {
    get<Index> {
        val profile = DataProvider.getProfileData()
        val content = DataProvider.getContentData()
        call.respond(
            FreeMarkerContent(
                "index.ftl", mapOf(
                    "profile" to profile,
                    "content" to content
                )
            )
        )
    }
}