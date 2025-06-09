package com.helios.web.portfolio.data

import com.helios.web.portfolio.data.model.AboutContent
import com.helios.web.portfolio.data.model.ContentData
import com.helios.web.portfolio.data.model.ExperienceItem
import com.helios.web.portfolio.data.model.ProfileData
import com.helios.web.portfolio.data.model.ProjectItem
import com.helios.web.portfolio.data.model.SectionData
import com.helios.web.portfolio.data.model.SocialLink
import com.helios.web.portfolio.data.model.TechnologyTag
import java.io.File

class DataProvider(portfolioConfigFile: File) {

    private val configurableDataProvider = ConfigurableDataProvider(portfolioConfigFile)

    fun getProfileData(): ProfileData {
        // Use the configurable provider for dynamic content
        return configurableDataProvider.getProfileData()
    }

    fun getContentData(): ContentData {
        // Use the configurable provider for dynamic content
        return configurableDataProvider.getContentData()
    }
}