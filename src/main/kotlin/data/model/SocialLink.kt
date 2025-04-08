package data.model

sealed class SocialLink(val name: String, open val url: String) {
    data class GitHub(override val url: String) : SocialLink("GitHub", url)
    data class LinkedIn(override val url: String) : SocialLink("LinkedIn", url)
    data class Twitter(override val url: String) : SocialLink("Twitter", url)
    data class Facebook(override val url: String) : SocialLink("Facebook", url)
}