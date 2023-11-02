[![codecov](https://codecov.io/gh/lambiengcode/waterbus/branch/main/graph/badge.svg?token=7KEMH26LHZ)](https://codecov.io/gh/lambiengcode/waterbus)[![libwebrtc](https://img.shields.io/badge/libwebrtc-119.6045.03-blue.svg)](https://chromium.googlesource.com/external/webrtc/+/branch-heads/6045)
[![Twitter Follow](https://img.shields.io/twitter/follow/waterbus.tech?style=social)](https://twitter.com/lambiengcode)[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat&logo=github)](https://github.com/lambiengcode)

<img src="./screenshots/banner.png" width="100%"/>

<img src="./screenshots/waterbus-demo.gif" width="100%"/>

# [Waterbus](https://docs.waterbus.tech): Online Meeting App using Flutter and WebRTC SFU (Selective Forwarding Unit)

<p align="justify">
<img src="https://github.com/lambiengcode/waterbus/blob/main/screenshots/launcher_icon_rounded.png?raw=true" width="180px" height=auto align="right" alt="Computador"/>
This is an Online Meeting App that utilizes Flutter and WebRTC technologies to provide users with a platform to conduct virtual meetings, conferences, and webinars. The app is built to provide seamless audio and video communication, as well as screen sharing, chat functionality, and file sharing.

The Waterbus concept has been used for physical transportation, but it can also be applied to online meeting platforms. A virtual Waterbus platform would allow users to travel along a virtual route and stop at designated locations to attend meetings. The platform could also incorporate gamification elements for increased engagement. This approach provides a unique and fun way for remote teams to collaborate while acknowledging the trend of using waterways for transportation.
</p>

## Current supported features

| Feature | Subscribe/Publish | AV1, VP8, H264 | Screen Sharing | Picture in Picture | Virtual Background | End to End Encryption | Record Media |
| :-----: | :---------------: | :-------: |  :-------: | :--------------: | :------------: | :-------------------: | :-------------------: |
|   iOS   |        🟢         |    🟢     |    🟢    |        🟡        |       🔴       |       🟡               |          🟡          |
| Android |        🟢         |    🟢     |    🟢|        🟡       |       🟡       |       🟡               |          🟡          |

🟢 = Available

🟡 = Coming soon (Work in progress)

🔴 = Not currently available (Possibly in the future)

## Online Meeting Diagram

<img src="./screenshots/waterbus-diagram.png" width="100%"/>

## Directiory Structure

```
waterbus/
├── README.md
├── RELEASE.md
├── analysis_options.yaml
├── android/
├── assets/
├── build/
├── codecov.yml
├── coverage/
├── ios/
├── launcher_icon_setup.yaml
├── lib/
│   ├── core/
│   ├── features/
│   │   ├── app/
│   │   ├── auth/
│   │   ├── chats/
│   │   ├── common/
│   │   ├── conversation/
│   │   ├── home/
│   │   ├── meeting/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── notifications/
│   │   ├── profile/
│   │   ├── schedule/
│   │   ├── settings/
│   ├── gen/
│   ├── main.dart
│   ├── services/
├── packages/
├── pubspec.lock
├── pubspec.yaml
├── run.sh
├── screenshots/
├── splash-setup.yaml
├── test/
├── tools/
└── waterbus.iml
```

## Requirements

Flutter
WebRTC
Firebase
Android Studio / Xcode

## Installation

1. Clone the repository git clone https://github.com/lambiengcode/waterbus.git
2. Run `flutter pub get` to install dependencies
3. Run the app using `flutter run`

## Usage

1. Sign up for an account
2. Create a new meeting
3. Share the meeting link with other participants
4. Start the meeting and utilize the available features

## Selfhosted Waterbus

- [Restful API](https://github.com/waterbustech/waterbus-restful-service)
- [WebRTC SFU Server](https://github.com/waterbustech/waterbus-sfu-meeting)
- [Waterbus Docs](https://docs.waterbus.tech)

## Benchmark (iOS - 720p - AV1 codec)

<img src="./screenshots/benchmark_plot.png" width="100%"/>

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=lambiengcode/waterbus&type=Date)](https://star-history.com/#lambiengcode/waterbus&Date)

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

Online Meeting, Flutter, WebRTC, Audio Communication, Video Communication, Screen Sharing, Chat Functionality, File Sharing, Firebase, Virtual Meetings, Conferences, Webinars, AV1 Codec, H264, VP8.
