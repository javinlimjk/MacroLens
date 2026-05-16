allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}
subprojects {
    plugins.withType<com.android.build.gradle.LibraryPlugin> {
        extensions.configure<com.android.build.gradle.LibraryExtension> {
            if (namespace.isNullOrEmpty()) {
                namespace = "com.macrolens.${project.name.replace("-", "_")}"
            }
        }

        project.tasks.withType<com.android.build.gradle.tasks.ProcessLibraryManifest>().configureEach {
            doFirst {
                val manifestFile = mainManifest.get().asFile
                if (manifestFile.exists()) {
                    val content = manifestFile.readText()
                    if (content.contains("package=")) {
                        manifestFile.writeText(content.replace(Regex("""\s+package="[^"]+""""), ""))
                    }
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
