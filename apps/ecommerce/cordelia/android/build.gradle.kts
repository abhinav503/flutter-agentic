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

// flutter_stripe's Android plugin declares
//   compileOnly "com.stripe:stripe-android-issuing-push-provisioning:1.1.0"
// whose own transitive `com.google.android.gms:play-services-tapandpay` is not
// published to any public Maven repo (it is a gated Google Pay artifact).
// `compileOnly` keeps it out of the shipped bundle, but AGP still resolves it
// into the *lint checks* classpath, so `:stripe_android:lintVitalAnalyzeRelease`
// fails every release build with "Could not find play-services-tapandpay".
//
// Excluded from the lint classpath only, never globally: the plugin's own
// sources reference those classes (Add-to-Wallet, push provisioning), so
// dropping it from `compileOnly` would stop stripe_android compiling at all.
// This app ships no Stripe Issuing features, so the lint checks that AAR
// publishes have nothing here to check.
subprojects {
    configurations
        .matching { it.name.endsWith("LintChecksClasspath") }
        .configureEach {
            exclude(
                group = "com.stripe",
                module = "stripe-android-issuing-push-provisioning",
            )
        }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
