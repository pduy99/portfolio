package data

import data.model.AboutContent
import data.model.ContentData
import data.model.ExperienceItem
import data.model.ProfileData
import data.model.ProjectItem
import data.model.SectionData
import data.model.SocialLink
import data.model.TechnologyTag

object DataProvider {
    fun getProfileData() = ProfileData(
        name = "Duy Pham",
        title = "Android Engineer",
        about = "I craft modern Android applications using the latest technologies. Always exploring new ways to build better, more performant native experiences.",
        sections = listOf(
            SectionData("about", "About"),
            SectionData("experience", "Experience", active = true),
            SectionData("projects", "Projects")
        ),
        social = listOf(
            SocialLink.GitHub("https://github.com/pduy99"),
            SocialLink.LinkedIn("https://www.linkedin.com/in/duy-pham-helios/")
        )
    )

    fun getContentData() = ContentData(
        about = AboutContent(
            paragraphs = listOf(
                "I'm a passionate and results-driven Android Developer with expertise in building high-performance applications and SDKs. Skilled in Kotlin, Jetpack Compose, and Kotlin Multiplatform, with a strong focus on Clean Architecture and modern development practices. Proven ability to optimize performance, improve code maintainability, and develop scalable solutions used by millions. Thrives in fast-paced environments and enjoys tackling technical challenges.",
                "Currently, I'm an Android Engineer at what3words. I contribute to the the what3words Android app; build the public and private UI components libraries allow others to integrate what3words functionality into their own applications.",
                "In my spare time, I'm usually playing chess, video games, hanging with my friends or exploring new technologies in native Android app development."
            )
        ),
        experience = listOf(
            ExperienceItem(
                dateRange = "October 2023 — Present",
                company = "what3words",
                companyUrl = "https://what3words.com/about",
                title = "Android Engineer",
                description = "Build and maintain core features of the what3words Android app. Design and develop public and private UI component libraries allow others to integrate what3words functionality into their own applications. Lead architecture and performance improvements for the new Jetpack Compose-based Map component (on top of Google Maps and MapBox). Contribute to the what3words automotive app.",
                technologies = listOf(
                    TechnologyTag("Kotlin Android"),
                    TechnologyTag("Kotlin Multiplatform"),
                    TechnologyTag("Jetpack Compose"),
                    TechnologyTag("Coroutines"),
                    TechnologyTag("Retrofit"),
                    TechnologyTag("Android for Cars App"),
                    TechnologyTag("MVVM"),
                    TechnologyTag("Clean Architecture"),
                    TechnologyTag("Dagger Hilt"),
                    TechnologyTag("UI Testing"),
                    TechnologyTag("GitHub Actions/CircleCI"),
                )
            ),
            ExperienceItem(
                dateRange = "March 2025 — Present",
                company = "Confidential",
                companyUrl = "",
                title = "Freelancer",
                description = "I independently developed a WearOS application designed for dental clinics to streamline daily operations for dentists and their staff. The app enhances workflow efficiency in dental practices by providing convenient access to essential functions through a wearable interface.",
                technologies = listOf(
                    TechnologyTag("WearOS"),
                    TechnologyTag("Jetpack Compose"),
                    TechnologyTag("Ktor"),
                    TechnologyTag("MVVM"),
                    TechnologyTag("Clean Architecture"),
                    TechnologyTag("Dagger Hilt"),
                )
            ),
            ExperienceItem(
                dateRange = "November 2021 — October 2023",
                company = "Fossil Vietnam",
                companyUrl = "https://www.fossilgroup.com/",
                title = "Device Integration Engineer",
                description = "Participated in building a new Wearables Framework (inspired by Android WearOS) from scratch for the next generation of Fossil smartwatches. Spearheaded the development and ownership of the core modules of the framework, including SensorManager, HealthServiceManager, and LocationManager. Optimized code and memory usage, enabling the framework to run on smartwatches with only 5MB of RAM, supporting up to 12 installed applications.",
                technologies = listOf(
                    TechnologyTag("Android Framework"),
                    TechnologyTag("Java"),
                    TechnologyTag("Protocol Buffers"),
                    TechnologyTag("SNI/JNI"),
                )
            ),
            ExperienceItem(
                dateRange = "May 2021 — November 2021",
                company = "Fossil Vietnam",
                companyUrl = "https://www.fossilgroup.com/",
                title = "Android SDK Engineer, Intern",
                description = "Developed a cross-platform SDK using Kotlin Multiplatform to enable Bluetooth communication between mobile apps and Fossil smartwatches, reducing maintenance overhead by sharing a single codebase across Android and iOS platforms.",
                technologies = listOf(
                    TechnologyTag("Kotlin KMP"),
                    TechnologyTag("Bluetooth Low Energy"),
                    TechnologyTag("Realm Database"),
                )
            ),
            ExperienceItem(
                dateRange = "December 2020 — March 2021",
                company = "SaigonSmart",
                companyUrl = "",
                title = "Android Developer, Contractor",
                description = "Worked as a part-time developer during university, developing and publishing two Android applications on the Play Store.",
                technologies = listOf(
                    TechnologyTag("Kotlin Android"),
                    TechnologyTag("MongoDB"),
                    TechnologyTag("Kotlin Coroutines"),
                )
            ),
        ),
        projects = listOf(
            ProjectItem(
                name = "SunVerta Translation App",
                url = "https://github.com/pduy99/HeliosTranslator",
                imageUrl = "/images/projects/sunverta.jpg",
                description = "SunVerta is a comprehensive translation application built with Kotlin Compose Multiplatform (KMP), offering multiple translation methods.",
                technologies = listOf(
                    TechnologyTag("Kotlin Multiplatform"),
                    TechnologyTag("Jetpack Compose"),
                    TechnologyTag("Coroutines"),
                    TechnologyTag("SQLDelight"),
                    TechnologyTag("Ktor"),
                    TechnologyTag("Material Design"),
                    TechnologyTag("CameraX"),
                    TechnologyTag("MLKit"),
                    TechnologyTag("Dagger Hilt"),
                    TechnologyTag("CircleCI"),
                )
            ),
            ProjectItem(
                name = "KMM File System",
                url = "https://github.com/pduy99/KMMFile",
                imageUrl = "/images/projects/KMMFile.jpg",
                description = "KMMFile is an utility library helps applications working with File System (Android/iOS) in Kotlin Multiplatform.",
                technologies = listOf(
                    TechnologyTag("Kotlin Multiplatform"),
                    TechnologyTag("Maven Publishing"),
                )
            ),
            ProjectItem(
                name = "Personal Portfolio Template",
                url = "#",
                imageUrl = "/images/projects/portfolio_website.png",
                description = "A modern, customizable portfolio template built with Kotlin and Freemarker. Features a clean, responsive design inspired by popular portfolio layouts, supporting dynamic content management and easy customization.",
                technologies = listOf(
                    TechnologyTag("Kotlin Ktor Server"),
                    TechnologyTag("Freemarker Template"),
                    TechnologyTag("Tailwind CSS"),
                )
            ),
        ),
    )
}