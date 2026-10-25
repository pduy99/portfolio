package com.helios.web.portfolio.data.model

data class ExperienceItem(
    val dateRange: String,
    val company: String,
    val companyUrl: String,
    val title: String,
    val description: String,
    val technologies: List<TechnologyTag>,
    /** Path of the case study about this role, when there is one. */
    val caseStudyPath: String? = null,
)