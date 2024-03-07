<p align="center">
  <img src="https://github.com/lambiengcode/waterbus/blob/main/screenshots/launcher_icon_rounded.png?raw=true" width="180px" height=auto alt="Computador"/>
</p>

<h1 align="center"><a href="https://docs.waterbus.tech">Waterbus</a></h1>
<h3 align="center">Online Meeting App using Flutter and WebRTC SFU (Selective Forwarding Unit)</h3>
<p align="center">
  🤙 This is an Online Meeting App that utilizes Flutter and WebRTC technologies to provide users with a platform to conduct virtual meetings, conferences, and webinars. The app is built to provide seamless audio and video communication, as well as screen sharing, chat functionality, and file sharing.
</p>
<div class="badges" align="center">
<p><a href="https://codecov.io/gh/lambiengcode/waterbus"><img src="https://codecov.io/gh/lambiengcode/waterbus/branch/main/graph/badge.svg?token=7KEMH26LHZ" alt="codecov"></a><a href="https://www.codefactor.io/repository/github/lambiengcode/waterbus"><img src="https://www.codefactor.io/repository/github/lambiengcode/waterbus/badge" alt="CodeFactor"></a><a href="https://sonarcloud.io/summary/new_code?id=lambiengcode_waterbus"><img src="https://sonarcloud.io/api/project_badges/measure?project=lambiengcode_waterbus&amp;metric=alert_status" alt="Quality Gate Status"></a><img src="https://img.shields.io/github/actions/workflow/status/lambiengcode/waterbus/ci.yml" alt="GitHub Workflow Status (with event)"><img src="https://img.shields.io/github/issues/lambiengcode/waterbus" alt="GitHub issues"><a href="https://chromium.googlesource.com/external/webrtc/+/branch-heads/6099"><img src="https://img.shields.io/badge/libwebrtc-120.6099.19-yellow.svg" alt="libwebrtc"></a><img src="https://img.shields.io/cocoapods/v/KaiRTC" alt="Cocoapods Version">
<a href="https://twitter.com/lambiengcode"><img src="https://img.shields.io/twitter/follow/waterbus.tech?style=social" alt="Twitter Follow"></a><a href="https://github.com/lambiengcode"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat&amp;logo=github" alt="PRs Welcome"></a></p>
</div>

<p align="center">
  <a href="https://docs.waterbus.tech">Website</a> &bull;
  <a href="https://github.com/lambiengcode/waterbus/wiki">Wiki</a> &bull;
  <a href="https://github.com/lambiengcode/waterbus/blob/main/LICENSE">License</a>
</p>

[![Banner](./screenshots/banner-dark.png)](https://docs.waterbus.tech#gh-dark-mode-only)
[![Banner](./screenshots/banner.png)](https://docs.waterbus.tech#gh-light-mode-only)
<h3 align="center">👉 The Virtual Background feature supports both Android and iOS</h3>
<br/>
<div align="center">
<p><a href="https://youtube.com/shorts/Ms4avix05uY"><img src="https://ytcards.demolab.com/?id=Ms4avix05uY&amp;title=Virtual%20Background%20on%20iOS%20%28VisionKit%20for%20Person%20segment%29&amp;lang=en&amp;timestamp=1709774408&amp;background_color=%230d1117&amp;title_color=%23ffffff&amp;stats_color=%23dedede&amp;max_title_lines=2&amp;width=250&amp;border_radius=10&amp;duration=21" alt="Virtual Background on iOS (VisionKit for Person segment)" title="Virtual Background on iOS (VisionKit for Person segment"></a>
<a href="https://youtube.com/shorts/PDIDbVoHT5o"><img src="https://ytcards.demolab.com/?id=PDIDbVoHT5o&amp;title=Virtual%20Background%20on%20Android%20%28Mediapipe%20for%20Image%20segment%29&amp;lang=en&amp;timestamp=1709774408&amp;background_color=%230d1117&amp;title_color=%23ffffff&amp;stats_color=%23dedede&amp;max_title_lines=2&amp;width=250&amp;border_radius=10&amp;duration=27" alt="Virtual Background on Android (Mediapipe for Image segment)" title="Virtual Background on Android (Mediapipe for Image segment"></a></p>
</div>


### ⚡ Current supported features

| Feature | Subscribe/Publish | Screen Sharing | Picture in Picture | Virtual Background | End to End Encryption | Record Media |
| :-----: | :---------------: | :------------: | :----------------: | :----------------: | :-------------------: | :----------: |
|   iOS   |        🟢         |       🟢       |         🟢         |         🟢         |          🟢           |      🟡      |
| Android |        🟢         |       🟢       |         🟢         |         🟢         |          🟢           |      🟡      |

### 💥 Codec supported
| Codec | VP8 | VP9 | H264 | H265 | AV1 |
| :-----: | :---------------: | :------------: | :------------: | :----------------: | :--------------------------------: |
|   iOS   |        🟢         |       🟢       |       🟢       |         🟢         |         🟢         |
| Android |        🟢         |       🟢       |       🟢       |         🟢         |         🟢         |

🟢 = Available

🟡 = Coming soon (Work in progress)

🔴 = Not currently available (Possibly in the future)

> [!NOTE]  
> - `AV1` supported on iOS 14 and above, Android 14 and above.
> - `E2EE` only supported `H264`, `VP8` and `VP9`
> - Video codec Android supported: Check at [Google Site](https://developer.android.com/guide/topics/media/platform/supported-formats#video-codecs)

> [!WARNING]  
> `Virtual Background` is still in beta so it will not be stable. It is developed using [MediaPipe](https://developers.google.com/mediapipe) for `Android` and [VisionKit](https://developer.apple.com/documentation/vision/vngeneratepersoninstancemaskrequest) for `iOS`

<details>
<summary> 🖼️ Online Meeting Diagram</summary>

[![Diagram](./screenshots/waterbus-diagram-dark.png)](https://docs.waterbus.tech#gh-dark-mode-only)
[![Diagram](./screenshots/waterbus-diagram.png)](https://docs.waterbus.tech#gh-light-mode-only)

</details>

<details>
<summary> 📂 Repository Structure</summary>

```sh
└── waterbus/
    ├── .githooks/
    │   ├── pre-commit
    │   └── pre-push
    ├── .github/
    │   ├── FUNDING.yml
    │   ├── ISSUE_TEMPLATE/
    │   ├── dependabot.yml
    │   └── workflows/
    │       ├── ci.yml
    │       └── release.yml
    ├── .metadata
    ├── analysis_options.yaml
    ├── android/
    │   ├── app/
    │   │   ├── build.gradle
    │   │   ├── google-services.json
    │   │   ├── proguard-rules.pro
    │   │   └── src/
    │   ├── build.gradle
    │   ├── gradle/
    │   │   └── wrapper/
    │   └── settings.gradle
    ├── benchmark/
    │   ├── benchmark.txt
    │   └── plot_benchmark_results.gp
    ├── codecov.yml
    ├── ios/
    │   ├── BroadcastAppGroup/
    │   │   └── BroadcastAppGroupHandler.swift
    │   ├── BroadcastWaterbus/
    │   │   ├── Atomic.swift
    │   │   ├── BroadcastWaterbus.entitlements
    │   │   ├── DarwinNotificationCenter.swift
    │   │   ├── Info.plist
    │   │   ├── SampleHandler.swift
    │   │   ├── SampleUploader.swift
    │   │   └── SocketConnection.swift
    │   ├── Flutter/
    │   │   ├── AppFrameworkInfo.plist
    │   │   ├── Debug.xcconfig
    │   │   └── Release.xcconfig
    │   ├── Podfile
    │   ├── Podfile.lock
    │   ├── Runner/
    │   │   ├── AppDelegate.swift
    │   │   ├── Assets.xcassets/
    │   │   ├── Base.lproj/
    │   │   ├── GoogleService-Info.plist
    │   │   ├── Info.plist
    │   │   ├── Runner-Bridging-Header.h
    │   │   └── Runner.entitlements
    │   ├── Runner.xcodeproj/
    │   │   ├── project.pbxproj
    │   │   ├── project.xcworkspace/
    │   │   └── xcshareddata/
    │   ├── Runner.xcworkspace/
    │   │   ├── contents.xcworkspacedata
    │   │   └── xcshareddata/
    │   └── clean-pods.sh
    ├── launcher_icon_setup.yaml
    ├── lib/
    │   ├── core/
    │   │   ├── app/
    │   │   ├── constants/
    │   │   ├── error/
    │   │   ├── helpers/
    │   │   ├── injection/
    │   │   ├── navigator/
    │   │   ├── types/
    │   │   ├── usecase/
    │   │   └── utils/
    │   ├── features/
    │   │   ├── app/
    │   │   ├── auth/
    │   │   ├── chats/
    │   │   ├── common/
    │   │   ├── conversation/
    │   │   ├── home/
    │   │   ├── meeting/
    │   │   ├── notifications/
    │   │   ├── profile/
    │   │   ├── schedule/
    │   │   └── settings/
    │   ├── gen/
    │   │   ├── assets.gen.dart
    │   │   └── fonts.gen.dart
    │   └── main.dart
    ├── packages/
    │   ├── auth/
    │   │   ├── .metadata
    │   │   ├── analysis_options.yaml
    │   │   ├── lib/
    │   │   ├── pubspec.yaml
    │   │   └── test/
    │   └── sizer/
    │       ├── .metadata
    │       ├── analysis_options.yaml
    │       ├── lib/
    │       └── pubspec.yaml
    ├── pubspec.lock
    ├── pubspec.yaml
    ├── run.sh
    ├── screenshots/
    ├── splash-setup.yaml
    ├── test/
    │   ├── constants/
    │   │   └── sample_file_path.dart
    │   ├── features/
    │   │   ├── auth/
    │   │   ├── meeting/
    │   │   └── profile/
    │   └── fixtures/
    │       ├── auth/
    │       ├── fixture_reader.dart
    │       └── meeting/

```

</details>

## 🚀 Getting Started

### 🔧 Installation

1. Clone the waterbus repository:
```sh
git clone https://github.com/lambiengcode/waterbus
```

2. Change to the project directory:
```sh
cd waterbus
```

3. Install the dependencies:
```sh
flutter pub get
```

### 🤖 Run flutter app

```sh
flutter run
```

### 🧪 Tests
```sh
flutter test
```

---

## 🔥 Usage

1. Sign up for an account
2. Create a new meeting
3. Share the meeting link with other participants
4. Start the meeting and utilize the available features

## 🛠 Selfhosted Waterbus

- [Restful API](https://github.com/waterbustech/waterbus-restful-service)
- [WebRTC SFU Server](https://github.com/waterbustech/waterbus-sfu-meeting)
- [Waterbus Docs](https://docs.waterbus.tech)

## ⏲️ Benchmarking

- This part is benchmarking video codecs within a 60-second duration of an online meeting on an iPhone 13 running iOS 17.0.2. The codecs included in the benchmark are VP8, VP9, H.264, H.265, and AV1.
- The benchmark aims to quickly compare the performance differences between these codecs during a short online meeting session.

#### 📱 Device Specifications

- **Model:** iPhone 13
- **Operating System:** iOS 17.0.2

#### 🎯 Results

You can view the benchmark results in the generated plots and data files. Here's how you can interpret the results:

<details>
  <summary>VP8</summary>
  - Total encode time: 9325 (µs) in 60s call

  <picture>
    <source width="100%" alt="lambiengcode" media="(prefers-color-scheme: dark)" srcset="./benchmark/vp8-benchmark-plot.png">
    <img width="100%" alt="lambiengcode" src="./benchmark/vp8-benchmark-plot-light.png">
  </picture>
</details>
<details>
  <summary>VP9</summary>
  - Total encode time: 12091 (µs) in 60s call
  
  <picture>
    <source width="100%" alt="lambiengcode" media="(prefers-color-scheme: dark)" srcset="./benchmark/vp9-benchmark-plot.png">
    <img width="100%" alt="lambiengcode" src="./benchmark/vp9-benchmark-plot-light.png">
  </picture>
</details>
<details>
  <summary>H264</summary>
  - Total encode time: 11127 (µs) in 60s call
  
  <picture>
    <source width="100%" alt="lambiengcode" media="(prefers-color-scheme: dark)" srcset="./benchmark/h264-benchmark-plot.png">
    <img width="100%" alt="lambiengcode" src="./benchmark/h264-benchmark-plot-light.png">
  </picture>
</details>
<details>
  <summary>H265</summary>
  - Total encode time: 9264 (µs) in 60s call
  
  <picture>
    <source width="100%" alt="lambiengcode" media="(prefers-color-scheme: dark)" srcset="./benchmark/h265-benchmark-plot.png">
    <img width="100%" alt="lambiengcode" src="./benchmark/h265-benchmark-plot-light.png">
  </picture>
</details>
<details>
  <summary>AV1</summary>
  - Total encode time: 13615 (µs) in 60s call
  
  <picture>
    <source width="100%" alt="lambiengcode" media="(prefers-color-scheme: dark)" srcset="./benchmark/av1-benchmark-plot.png">
    <img width="100%" alt="lambiengcode" src="./benchmark/av1-benchmark-plot-light.png">
  </picture>
</details>

## Enjoying this project? 💙

[![Stargazers repo roster for @lambiengcode/waterbus](https://reporoster.com/stars/notext/dark/lambiengcode/waterbus)](https://github.com/lambiengcode/waterbus/stargazers/#lambiengcode/waterbus&Date#gh-dark-mode-only)
[![Stargazers repo roster for @lambiengcode/waterbus](https://reporoster.com/stars/notext/lambiengcode/waterbus)](https://github.com/lambiengcode/waterbus/stargazers/#gh-light-mode-only)

Support it by joining [stargazers](https://github.com/lambiengcode/waterbus/stargazers) for this repository. ⭐

Also, follow [maintainers](https://github.com/lambiengcode) on GitHub for our next creations!

### Stars History

[![Star History Chart](https://api.star-history.com/svg?repos=lambiengcode/waterbus&type=Date&theme=dark)](https://star-history.com/#lambiengcode/waterbus&Date#gh-dark-mode-only)
[![Star History Chart](https://api.star-history.com/svg?repos=lambiengcode/waterbus&type=Date)](https://star-history.com/#lambiengcode/waterbus&Date#gh-light-mode-only)

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue if you encounter any problems or have suggestions for improvements.

## Contact Information

If you have any questions or suggestions related to this application, please contact me via email: `lambiengcode@waterbus.tech` or `lambiengcode@gmail.com`.
