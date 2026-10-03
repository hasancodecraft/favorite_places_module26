import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Keep the real key in a local file, outside GitHub.
val mapsProperties = Properties()
val mapsFile = rootProject.file("maps.properties")
if (mapsFile.exists()) {
    mapsFile.inputStream().use { mapsProperties.load(it) }
}
val mapsApiKey = mapsProperties.getProperty("MAPS_API_KEY", "").trim()
if (mapsApiKey.isEmpty() || mapsApiKey == "PASTE_YOUR_ANDROID_MAPS_API_KEY_HERE") {
    throw GradleException(
        "Add your Google Maps key to android/maps.properties. " +
        "Use android/maps.properties.example as the template."
    )
}

android {
    namespace = "com.example.favorite_places"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.favorite_places"
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
    }

    buildTypes {
        release {
            // Debug signing is enough for a local assignment build.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
