package com.helios.web.portfolio.data.model

data class ProjectItem(
    val name: String,
    val url: String,
    val imageUrl: String,
    val description: String,
    val stars: Int? = null,
    val technologies: List<TechnologyTag> = emptyList()
)