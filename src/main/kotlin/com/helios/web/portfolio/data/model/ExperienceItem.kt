package com.helios.web.portfolio.data.model

data class ExperienceItem(
    val dateRange: String,
    val company: String,
    val companyUrl: String,
    val title: String,
    val description: String,
    val technologies: List<TechnologyTag>
)