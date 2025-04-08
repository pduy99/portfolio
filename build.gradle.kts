
plugins {
    kotlin("jvm") version "1.9.0"
    application
}

group = "com.helios"
version = "1.0-SNAPSHOT"

application {
    mainClass.set("MainKt")
}

dependencies {
    implementation("io.ktor:ktor-server-core-jvm:2.3.4")
    implementation("io.ktor:ktor-server-netty-jvm:2.3.4")
    implementation("io.ktor:ktor-server-freemarker-jvm:2.3.4")
    implementation("io.ktor:ktor-server-html-builder-jvm:2.3.4")
    implementation("ch.qos.logback:logback-classic:1.4.11")
}

repositories {
    mavenCentral()
}
