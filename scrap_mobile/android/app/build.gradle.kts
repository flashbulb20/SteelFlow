plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.scrap_mobile"
    compileSdk = flutter.compileSdkVersion

    // ✅ [중요] NDK 버전 강제 지정
    // google_maps_flutter_android 및 flutter_plugin_android_lifecycle 플러그인이
    // Android NDK 27.0.12077973 버전을 요구하므로, 명시적으로 지정합니다.
    // 기존 flutter.ndkVersion은 보통 26.x.x 버전을 사용하므로 충돌이 발생했습니다.
    ndkVersion = "27.0.12077973" // ★ 수정됨

    compileOptions {
        // Java 11 버전 지정 (Gradle 빌드와 Kotlin 모두 동일 버전 유지)
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        // Kotlin JVM 타겟 버전 설정
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // 앱의 고유 식별자 (패키지명)
        applicationId = "com.example.scrap_mobile"

        // Flutter SDK가 제공하는 build 설정 값들 사용
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // 현재는 디버그 키로 서명 (릴리즈 배포 시 signingConfig 수정 필요)
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    // Flutter 소스 루트 경로 지정
    source = "../.."
}
