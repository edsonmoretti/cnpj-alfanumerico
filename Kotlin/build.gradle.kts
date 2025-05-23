plugins {
    kotlin("jvm") version "1.8.0"
    application
}

group = "com.edsonmoretti"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}

kotlin {
    jvmToolchain(11)
}

application {
    mainClass.set("com.edsonmoretti.cnpj.MainKt")
}
