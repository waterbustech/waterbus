rm -rf Pods
rm -rf Podfile.lock
flutter clean
flutter pub get
# pod install --repo-update
pod install
