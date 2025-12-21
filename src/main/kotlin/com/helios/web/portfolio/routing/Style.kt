package com.helios.web.portfolio.routing

import io.ktor.resources.Resource
import io.ktor.server.http.content.resolveResource
import io.ktor.server.resources.get
import io.ktor.server.routing.Route

@Resource("/styles/main.css")
class MainCss

/**
 * Register the styles, [MainCss] route (/styles/main.css)
 */
fun Route.styles() {
    /**
     * On a GET request to the [MainCss] route, it returns the `style.css` file from the resources.
     *
     * Here we could preprocess or join several CSS/SASS/LESS.
     */
    get<MainCss> {
        call.respond(call.resolveResource("style.css")!!, null)
    }
}