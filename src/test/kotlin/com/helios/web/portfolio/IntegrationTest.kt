package com.helios.web.portfolio

import io.ktor.client.request.get
import io.ktor.client.statement.bodyAsText
import io.ktor.http.HttpStatusCode
import io.ktor.server.config.MapApplicationConfig
import io.ktor.server.testing.testApplication
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class IntegrationTest {

    @Test
    fun `test index route returns 200 and content`() = testApplication {
        environment {
            config = MapApplicationConfig(
                "storage.cv.directory" to "."
            )
        }

        application {
            module()
        }

        val response = client.get("/")

        assertEquals(HttpStatusCode.OK, response.status)
        val body = response.bodyAsText()
        assertTrue(body.contains("Duy Pham"), "Response should contain profile name")
        assertTrue(body.contains("Android Engineer"), "Response should contain title")
    }
}
