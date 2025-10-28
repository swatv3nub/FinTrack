## iOS Configuration

### Minimum Requirements
- iOS 12.0 or higher
- Xcode 14.0 or higher
- CocoaPods

### Setup
1. Navigate to iOS folder:
```bash
cd ios
```

2. Install CocoaPods dependencies:
```bash
pod install
```

3. Open workspace in Xcode:
```bash
open Runner.xcworkspace
```

### Release Build
To build a release IPA:
```bash
flutter build ios --release
```

### App Store Submission
1. Configure signing in Xcode
2. Update app version in `pubspec.yaml`
3. Create archive in Xcode
4. Upload to App Store Connect

### Info.plist Configurations
No special permissions required for this app.
