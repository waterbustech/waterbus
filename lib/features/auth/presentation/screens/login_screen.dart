// ignore_for_file: depend_on_referenced_packages

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auth/auth.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/auth/presentation/widgets/button_login.dart';
import 'package:waterbus/gen/assets.gen.dart';
import 'package:waterbus/gen/fonts.gen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 300.sp,
              child: Column(
                children: [
                  SizedBox(height: 15.sp),
                  Image.asset(
                    Assets.images.imgAppLogo.path,
                    height: 100.sp,
                  ),
                  SizedBox(height: 12.sp),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.sp,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.pixelify,
                                height: 1.2,
                                color: mCL,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Welcome to\n',
                                  style: TextStyle(
                                    color: Color(0xFFEFB7E9),
                                  ),
                                ),
                                TextSpan(
                                  text: 'Waterbus',
                                  style: TextStyle(
                                    color: colorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.sp),
                          SizedBox(
                            width: 250.sp,
                            child: Text(
                              'Cutting Edge Video Conferencing built on latest WebRTC SDK. Multi-attendee calls built on SFU. Your meeting will be more professional with Virtual Background and multitasking is better with Picture in Picture.',
                              softWrap: true,
                              strutStyle: StrutStyle.disabled,
                              textAlign: TextAlign.justify,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300,
                                    height: 1.4,
                                  ),
                            ),
                          ),
                          const Spacer(),
                          kIsWeb
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(30.sp),
                                  child: Auth().loginRenderWidget(),
                                )
                              : ButtonLogin(
                                  title: 'Continue with Google',
                                  iconAsset: Assets.icons.icGoogle.path,
                                  onPressed: () async {
                                    AppBloc.authBloc
                                        .add(LogInWithGoogleEvent());
                                  },
                                ),
                          SizedBox(height: 20.sp),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5.sp,
                                  ),
                              children: const [
                                TextSpan(
                                  text: 'By signing up, you agree to our ',
                                ),
                                TextSpan(
                                  text: 'Terms, Privacy Policy',
                                  style: TextStyle(color: colorPrimary),
                                ),
                                TextSpan(
                                  text: ' and ',
                                ),
                                TextSpan(
                                  text: 'Cookie Use.',
                                  style: TextStyle(color: colorPrimary),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.images.loginBannerJpeg.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
