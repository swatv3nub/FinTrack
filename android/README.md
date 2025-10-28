## Android Configuration

### Minimum Requirements
- minSdkVersion: 21 (Android 5.0 Lollipop)
- targetSdkVersion: 33 (Android 13)
- compileSdkVersion: 33

### Permissions
No special permissions required. The app uses local storage only.

### ProGuard Rules (for release builds)
```proguard
# Hive
-keep class * extends hive.HiveObject
-keep class * implements hive.HiveAdapter
```

### Release Build
To build a release APK:
```bash
flutter build apk --release
```

To build an App Bundle (for Play Store):
```bash
flutter build appbundle --release
```

The release APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`
