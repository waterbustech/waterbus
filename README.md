[![codecov](https://codecov.io/gh/lambiengcode/waterbus/branch/main/graph/badge.svg?token=7KEMH26LHZ)](https://codecov.io/gh/lambiengcode/waterbus)[![CodeFactor](https://www.codefactor.io/repository/github/lambiengcode/waterbus/badge)](https://www.codefactor.io/repository/github/lambiengcode/waterbus)[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=lambiengcode_waterbus&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=lambiengcode_waterbus)![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/lambiengcode/waterbus/ci.yml)![GitHub issues](https://img.shields.io/github/issues/lambiengcode/waterbus)[![libwebrtc](https://img.shields.io/badge/libwebrtc-120.6099.19-yellow.svg)](https://chromium.googlesource.com/external/webrtc/+/branch-heads/6099)![Cocoapods Version](https://img.shields.io/cocoapods/v/KaiRTC)
[![Twitter Follow](https://img.shields.io/twitter/follow/waterbus.tech?style=social)](https://twitter.com/lambiengcode)[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat&logo=github)](https://github.com/lambiengcode)

[![Banner](./screenshots/banner-dark.png)](https://docs.waterbus.tech#gh-dark-mode-only)
[![Banner](./screenshots/banner.png)](https://docs.waterbus.tech#gh-light-mode-only)

<!-- [![Demo](./screenshots/waterbus-demo.gif)](https://docs.waterbus.tech#gh-dark-mode-only) -->

# [Waterbus](https://docs.waterbus.tech): Online Meeting App using Flutter and WebRTC SFU (Selective Forwarding Unit)

<p align="justify">
<img src="https://github.com/lambiengcode/waterbus/blob/main/screenshots/launcher_icon_rounded.png?raw=true" width="180px" height=auto align="right" alt="Computador"/>
This is an Online Meeting App that utilizes Flutter and WebRTC technologies to provide users with a platform to conduct virtual meetings, conferences, and webinars. The app is built to provide seamless audio and video communication, as well as screen sharing, chat functionality, and file sharing.

The Waterbus concept has been used for physical transportation, but it can also be applied to online meeting platforms. A virtual Waterbus platform would allow users to travel along a virtual route and stop at designated locations to attend meetings. The platform could also incorporate gamification elements for increased engagement. This approach provides a unique and fun way for remote teams to collaborate while acknowledging the trend of using waterways for transportation.

</p>

## Current supported features

| Feature | Subscribe/Publish | Screen Sharing | Picture in Picture | Virtual Background | End to End Encryption | Record Media |
| :-----: | :---------------: | :------------: | :----------------: | :----------------: | :-------------------: | :----------: |
|   iOS   |        🟢         |       🟢       |         🟢         |         🟢         |          🟢           |      🟡      |
| Android |        🟢         |       🟢       |         🟢         |         🟢         |          🟢           |      🟡      |

## Codec supported
| Codec | VP8 | VP9 | H264 | H265 | AV1 |
| :-----: | :---------------: | :------------: | :------------: | :----------------: | :--------------------------------: |
|   iOS   |        🟢         |       🟢       |       🟢       |         🟢         |         🟢         |
| Android |        🟢         |       🟢       |       🟢       |         🟢         |         🟢         |

### Notes:
> [!NOTE]  
> `AV1` supported on iOS 14 and above, Android 14 and above.
> `E2EE` only supported `H264`, `VP8` and `VP9`
> Video codec Android supported: Check at [Google Site](https://developer.android.com/guide/topics/media/platform/supported-formats#video-codecs)

> [!WARNING]  
> `Virtual Background` is still in beta so it will not be stable. It is developed using [MediaPipe](https://developers.google.com/mediapipe) for `Android` and [VisionKit](https://developer.apple.com/documentation/vision/vngeneratepersoninstancemaskrequest) for `iOS`

🟢 = Available

🟡 = Coming soon (Work in progress)

🔴 = Not currently available (Possibly in the future)

## Online Meeting Diagram

[![Diagram](./screenshots/waterbus-diagram-dark.png)](https://docs.waterbus.tech#gh-dark-mode-only)
[![Diagram](./screenshots/waterbus-diagram.png)](https://docs.waterbus.tech#gh-light-mode-only)

## 📂 Repository Structure

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

### 🤖 Running waterbus

```sh
flutter run
```

### 🧪 Tests
```sh
flutter test
```

---

## Usage

1. Sign up for an account
2. Create a new meeting
3. Share the meeting link with other participants
4. Start the meeting and utilize the available features

## 🛠 Selfhosted Waterbus

- [Restful API](https://github.com/waterbustech/waterbus-restful-service)
- [WebRTC SFU Server](https://github.com/waterbustech/waterbus-sfu-meeting)
- [Waterbus Docs](https://docs.waterbus.tech)

## Benchmarking

- This part is benchmarking video codecs within a 60-second duration of an online meeting on an iPhone 13 running iOS 17.0.2. The codecs included in the benchmark are VP8, VP9, H.264, H.265, and AV1.
- The benchmark aims to quickly compare the performance differences between these codecs during a short online meeting session.

[![Benchmark](./benchmark/h265-benchmark-plot.png)](https://docs.waterbus.tech#gh-dark-mode-only)
[![Benchmark](./benchmark/h265-benchmark-plot-light.png)](https://docs.waterbus.tech#gh-light-mode-only)

### Device Specifications

- **Model:** iPhone 13
- **Operating System:** iOS 17.0.2

### Results

You can view the benchmark results in the generated plots and data files. Here's how you can interpret the results:

<details open>
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


## Roadmap

- Check at [Roadmap](./roadmap.md)

## Support

Don't forget to leave a star ⭐️.

<img src="https://octodex.github.com/images/Fintechtocat.png" width=300 height=300/>

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=lambiengcode/waterbus&type=Date&theme=dark)](https://star-history.com/#lambiengcode/waterbus&Date#gh-dark-mode-only)
[![Star History Chart](https://api.star-history.com/svg?repos=lambiengcode/waterbus&type=Date)](https://star-history.com/#lambiengcode/waterbus&Date#gh-light-mode-only)

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue if you encounter any problems or have suggestions for improvements.

## Contact Information

If you have any questions or suggestions related to this application, please contact me via email: `lambiengcode@waterbus.tech` or `lambiengcode@gmail.com`.

## License

```terminal
MIT License

Copyright (c) 2023 lambiengcode

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Keywords

Online Meeting, Flutter, WebRTC, Audio Communication, Video Communication, Screen Sharing, Chat Functionality, File Sharing, Firebase, Virtual Meetings, Conferences, Webinars, AV1 Codec, H264, H265, VP9, VP8, Noise Suppresion.
