package data.model

data class ContentData(
    val about: AboutContent,
    val experience: List<ExperienceItem>,
    val projects: List<ProjectItem>
)