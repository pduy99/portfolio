val kotlin_version: String by project
val logback_version: String by project
val html_builder_version: String by project
val freemarker_version: String by project

plugins {
    kotlin("jvm") version "2.0.21"
    id("io.ktor.plugin") version "3.0.0"
    kotlin("plugin.serialization") version "2.0.20"
}

group = "com.helios.web.portfolio"
version = "1.0.0"

application {
    mainClass.set("io.ktor.server.netty.EngineMain")

    val isDevelopment: Boolean = project.ext.has("development")
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
}

repositories {
    mavenCentral()
}

ktor {
    fatJar {
        archiveFileName.set("helios-portfolio.jar")
    }
}

// Forwarded so the /stats authentication path can be exercised locally:
//   STATS_PASSWORD=secret ./gradlew test
// Absent, it is empty, which is the same as unset and keeps the fail-closed test honest.
tasks.test {
    environment("STATS_PASSWORD", System.getenv("STATS_PASSWORD") ?: "")
    environment("STATS_USER", System.getenv("STATS_USER") ?: "")
}

dependencies {
    implementation("io.ktor:ktor-server-core-jvm")
    implementation("io.ktor:ktor-server-netty")
    implementation("io.ktor:ktor-server-freemarker")
    implementation("io.ktor:ktor-server-resources")
    implementation("io.ktor:ktor-server-sessions")
    implementation("io.ktor:ktor-server-auth")
    implementation("io.ktor:ktor-server-conditional-headers")
    implementation("io.ktor:ktor-server-default-headers")
    implementation("io.ktor:ktor-server-partial-content")
    implementation("io.ktor:ktor-server-call-logging")
    implementation("io.ktor:ktor-network-tls-certificates")
    implementation("io.ktor:ktor-server-html-builder:$html_builder_version")
    implementation("ch.qos.logback:logback-classic:$logback_version")
    implementation("org.freemarker:freemarker:$freemarker_version")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.2")
    testImplementation("io.ktor:ktor-server-test-host-jvm")
    testImplementation("io.ktor:ktor-client-auth")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit:$kotlin_version")
}
