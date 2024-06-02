// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:auth/auth.dart';
import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/auth/presentation/widgets/button_login.dart';
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
              width: SizerUtil.isDesktop ? 330.sp : 100.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.images.imgAppLogo.path,
                      height: 140.sp,
                    ),
                    SizedBox(height: 20.sp),
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
                    kIsWeb
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30.sp),
                            child: Auth().loginRenderWidget(),
                          )
                        : Column(
                            children: [
                              ButtonLogin(
                                title: 'Continue with Google',
                                iconAsset: Assets.icons.icGoogle.path,
                                onPressed: () async {
                                  AppBloc.authBloc.add(LogInWithGoogleEvent());
                                },
                              ),
                              SizedBox(height: 8.sp),
                              ButtonLogin(
                                title: 'Sign in Anonymously',
                                iconAsset: Assets.icons.icIncognito.path,
                                onPressed: () async {
                                  AppBloc.authBloc.add(LogInAnonymously());
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
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Assets.images.worldMap.image(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
