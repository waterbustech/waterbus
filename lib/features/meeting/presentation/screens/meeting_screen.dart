// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_action_button.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meet_view.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.sp),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 30,
          ),
          child: Container(
            height: 80.sp,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.sp),
              ),
            ),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: 12.sp).add(
              EdgeInsets.only(bottom: 12.sp),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CallActionButton(icon: PhosphorIcons.microphone, onTap: () {}),
                CallActionButton(icon: PhosphorIcons.camera, onTap: () {}),
                CallActionButton(
                  icon: PhosphorIcons.chats_teardrop,
                  onTap: () {},
                ),
                CallActionButton(icon: PhosphorIcons.users, onTap: () {}),
                CallActionButton(
                  icon: PhosphorIcons.x,
                  backgroundColor: Colors.red,
                  onTap: () {
                    AppNavigator.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: MeetView(
                      displayName: 'Kai',
                      margin: EdgeInsets.symmetric(horizontal: 10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.sp),
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://avatars.githubusercontent.com/u/60530946?v=4',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: MeetView(
                      displayName: 'Waterbus Staff',
                      margin: EdgeInsets.symmetric(horizontal: 10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(14.sp),
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://avatars.githubusercontent.com/u/85678598?s=200&v=4',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
