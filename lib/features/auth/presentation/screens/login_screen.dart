import 'package:flutter/material.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/auth/presentation/widgets/button_login.dart';
import 'package:waterbus/features/home/presentation/widgets/empty_meet_view.dart';
import 'package:waterbus/gen/assets.gen.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: context.isDesktop ? 330.sp : 100.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.icons.launcherIcon.path,
                      height: 140.sp,
                    ),
                    SizedBox(
                      width: 250.sp,
                      child: Text(
                        "Open source video conferencing app built on latest WebRTC SDK.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50.sp, bottom: 30.sp),
                      child: const Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.sp),
                      child: Text(
                        'Login or register with the options below',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          color: mGB,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        ButtonLogin(
                          title: 'Sign in Anonymously',
                          iconAsset: Assets.icons.icIncognito.path,
                          onPressed: () async {
                            AppBloc.authBloc.add(AuthLoggedIn());
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.sp),
                    RichText(
                      text: TextSpan(
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w300,
                                  height: 1.5.sp,
                                ),
                        children: [
                          const TextSpan(
                            text: 'By signing up, you agree to our ',
                          ),
                          TextSpan(
                            text: 'Terms, Privacy Policy',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const TextSpan(
                            text: ' and ',
                          ),
                          TextSpan(
                            text: 'Cookie Use.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.sp),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceDim.withValues(
                      alpha: Theme.of(context).brightness == Brightness.light
                          ? 1
                          : 0.25,
                    ),
                alignment: Alignment.center,
                child: const EmptyMeetView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
