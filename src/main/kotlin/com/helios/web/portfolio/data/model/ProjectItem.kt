package com.helios.web.portfolio.data.model

data class ProjectItem(
    val name: String,
    val url: String,
    val imageUrl: String,
    val description: String,
    val stars: Int? = null,
    /** Path of this project's case study page, when it has one. */
    val caseStudyPath: String? = null,
    /** Short release state shown as a badge, such as "In closed testing". */
    val status: String? = null,
    val technologies: List<TechnologyTag> = emptyList()
)