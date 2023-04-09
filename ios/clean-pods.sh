rm -rf Pods
rm -rf Podfile.lock
flutter clean
flutter pub get
# pod install --repo-update
arch -x86_64 pod install
