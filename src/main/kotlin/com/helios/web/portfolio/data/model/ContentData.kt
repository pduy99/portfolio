package com.helios.web.portfolio.data.model

data class ContentData(
    val about: AboutContent,
    val experience: List<ExperienceItem>,
    val projects: List<ProjectItem>
)