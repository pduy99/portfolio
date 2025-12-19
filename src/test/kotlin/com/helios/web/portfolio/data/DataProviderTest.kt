package com.helios.web.portfolio.data

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import java.io.File

class DataProviderTest {

    @Test
    fun `test parsing portfolio config json`() {
        // Arrange
        val configFile = File("portfolio-config.json")
        val dataProvider = DataProvider(configFile)

        // Act
        val profile = dataProvider.getProfileData()
        val content = dataProvider.getContentData()

        // Assert Profile
        assertEquals("Duy Pham", profile.name)
        assertEquals("Android Engineer", profile.title)
        assertNotNull(profile.social.find { it.name == "GitHub" })

        // Assert Content
        assertNotNull(content.about.paragraphs)
        assert(content.about.paragraphs.isNotEmpty())

        assertNotNull(content.experience)
        assert(content.experience.isNotEmpty())
        assertEquals("what3words", content.experience[0].company)

        assertNotNull(content.projects)
        assert(content.projects.isNotEmpty())
    }
}
