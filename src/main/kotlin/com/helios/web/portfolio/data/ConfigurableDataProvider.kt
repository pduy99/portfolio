package com.helios.web.portfolio.data

import com.helios.web.portfolio.data.model.AboutContent
import com.helios.web.portfolio.data.model.ContentData
import com.helios.web.portfolio.data.model.ExperienceItem
import com.helios.web.portfolio.data.model.ProfileData
import com.helios.web.portfolio.data.model.ProjectItem
import com.helios.web.portfolio.data.model.SectionData
import com.helios.web.portfolio.data.model.SocialLink
import com.helios.web.portfolio.data.model.TechnologyTag
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.File

@Serializable
data class PortfolioConfig(
    val profile: ProfileConfig,
    val content: ContentConfig
)

@Serializable
data class ProfileConfig(
    val name: String,
    val title: String,
    val about: String,
    val social: List<SocialLinkConfig>
)

@Serializable
data class ContentConfig(
    val about: AboutConfig,
    val experience: List<ExperienceConfig>,
    val projects: List<ProjectConfig>
)

@Serializable
data class SocialLinkConfig(
    val type: String, // "GitHub" or "LinkedIn"
    val url: String
)

@Serializable
data class AboutConfig(
    val paragraphs: List<String>
)

@Serializable
data class ExperienceConfig(
    val dateRange: String,
    val company: String,
    val companyUrl: String?,
    val title: String,
    val description: String,
    val technologies: List<String>
)

@Serializable
data class ProjectConfig(
    val name: String,
    val url: String?,
    val imageUrl: String?,
    val description: String,
    val technologies: List<String>
)

class ConfigurableDataProvider(
    private val portfolioConfigFile: File
) {
    private val json = Json { prettyPrint = true }

    init {
        // Create default config file if it doesn't exist
        if (!portfolioConfigFile.exists()) {
            createDefaultConfig()
        }
    }

    fun getProfileData(): ProfileData {
        val config = loadConfig()
        return ProfileData(
            name = config.profile.name,
            title = config.profile.title,
            about = config.profile.about,
            sections = listOf(
                SectionData("about", "About"),
                SectionData("experience", "Experience", active = true),
                SectionData("projects", "Projects")
            ),
            social = config.profile.social.map { socialConfig ->
                when (socialConfig.type) {
                    "GitHub" -> SocialLink.GitHub(socialConfig.url)
                    "LinkedIn" -> SocialLink.LinkedIn(socialConfig.url)
                    else -> SocialLink.GitHub(socialConfig.url) // fallback
                }
            }
        )
    }

    fun getContentData(): ContentData {
        val config = loadConfig()
        return ContentData(
            about = AboutContent(config.content.about.paragraphs),
            experience = config.content.experience.map { exp ->
                ExperienceItem(
                    dateRange = exp.dateRange,
                    company = exp.company,
                    companyUrl = exp.companyUrl ?: "",
                    title = exp.title,
                    description = exp.description,
                    technologies = exp.technologies.map { TechnologyTag(it) }
                )
            },
            projects = config.content.projects.map { proj ->
                ProjectItem(
                    name = proj.name,
                    url = proj.url ?: "",
                    imageUrl = proj.imageUrl ?: "",
                    description = proj.description,
                    technologies = proj.technologies.map { TechnologyTag(it) }
                )
            }
        )
    }

    private fun loadConfig(): PortfolioConfig {
        return try {
            json.decodeFromString(portfolioConfigFile.readText())
        } catch (e: Exception) {
            // If config is corrupted, recreate it
            createDefaultConfig()
            json.decodeFromString(portfolioConfigFile.readText())
        }
    }

    private fun createDefaultConfig() {
        val defaultConfig = PortfolioConfig(
            profile = ProfileConfig(
                name = "Duy Pham",
                title = "Android Engineer",
                about = "I craft modern Android applications using the latest technologies. Always exploring new ways to build better, more performant native experiences.",
                social = listOf(
                    SocialLinkConfig("GitHub", "https://github.com/pduy99"),
                    SocialLinkConfig("LinkedIn", "https://www.linkedin.com/in/duy-pham-helios/")
                )
            ),
            content = ContentConfig(
                about = AboutConfig(
                    listOf(
                        "I'm a passionate and results-driven Android Developer with expertise in building high-performance applications and SDKs. Skilled in Kotlin, Jetpack Compose, and Kotlin Multiplatform, with a strong focus on Clean Architecture and modern development practices. Proven ability to optimize performance, improve code maintainability, and develop scalable solutions used by millions. Thrives in fast-paced environments and enjoys tackling technical challenges.",
                        "Currently, I'm an Android Engineer at what3words. I contribute to the the what3words Android app; build the public and private UI components libraries allow others to integrate what3words functionality into their own applications.",
                        "In my spare time, I'm usually playing chess, video games, hanging with my friends or exploring new technologies in native Android app development."
                    )
                ),
                experience = listOf(
                    ExperienceConfig(
                        dateRange = "October 2023 — Present",
                        company = "what3words",
                        companyUrl = "https://what3words.com/about",
                        title = "Android Engineer",
                        description = "Build and maintain core features of the what3words Android app. Design and develop public and private UI component libraries allow others to integrate what3words functionality into their own applications. Lead architecture and performance improvements for the new Jetpack Compose-based Map component (on top of Google Maps and MapBox). Contribute to the what3words automotive app.",
                        technologies = listOf(
                            "Kotlin Android",
                            "Kotlin Multiplatform",
                            "Jetpack Compose",
                            "Coroutines",
                            "Retrofit",
                            "Android for Cars App",
                            "MVVM",
                            "Clean Architecture",
                            "Dagger Hilt",
                            "UI Testing",
                            "GitHub Actions/CircleCI"
                        )
                    )
                    // Add other experiences here...
                ),
                projects = listOf(
                    ProjectConfig(
                        name = "SunVerta Translation App",
                        url = "https://github.com/pduy99/HeliosTranslator",
                        imageUrl = "/static/images/projects/sunverta.jpg",
                        description = "SunVerta is a comprehensive translation application built with Kotlin Compose Multiplatform (KMP), offering multiple translation methods.",
                        technologies = listOf(
                            "Kotlin Multiplatform",
                            "Jetpack Compose",
                            "Coroutines",
                            "SQLDelight",
                            "Ktor",
                            "Material Design",
                            "CameraX",
                            "MLKit",
                            "Dagger Hilt",
                            "CircleCI"
                        )
                    )
                    // Add other projects here...
                )
            )
        )

        portfolioConfigFile.writeText(json.encodeToString(defaultConfig))
    }
}