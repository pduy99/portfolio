package com.helios.web.portfolio.routing

import io.ktor.resources.Resource
import io.ktor.server.freemarker.FreeMarkerContent
import io.ktor.server.resources.get
import io.ktor.server.response.respond
import io.ktor.server.routing.Route

@Resource("/payment")
class Payment

fun Route.payment() {
    get<Payment> {
        call.respond(
            FreeMarkerContent(
                template = "payment.ftl",
                model = null,
            )
        )
    }
}