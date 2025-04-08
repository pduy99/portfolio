package data.model

data class ProfileData(
    val name: String,
    val title: String,
    val about: String,
    val sections: List<SectionData>,
    val social: List<SocialLink>
)
