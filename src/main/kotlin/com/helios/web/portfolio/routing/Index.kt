package com.helios.web.portfolio.routing

import com.helios.web.portfolio.data.DataProvider
import io.ktor.server.freemarker.FreeMarkerContent
import io.ktor.server.resources.get
import io.ktor.server.response.respond
import io.ktor.server.routing.Route
import java.io.File

fun Route.index() {
    get<Index> {
        val config = environment.config
        val cvDirectory = config.property("storage.cv.directory").getString()
        val configurableDataFile = File(cvDirectory, "portfolio-config.json")
        val dataProvider = DataProvider(configurableDataFile)

        val profile = dataProvider.getProfileData()
        val content = dataProvider.getContentData()
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