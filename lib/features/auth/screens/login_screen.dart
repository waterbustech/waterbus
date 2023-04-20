// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/auth/widgets/button_login.dart';
import 'package:waterbus/gen/assets.gen.dart';

// Package imports:

// Project imports:

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
        child: Column(
          children: [
            SizedBox(height: 15.sp),
            Image.asset(
              Assets.images.imgLogo.path,
              height: 40.sp,
            ),
            SizedBox(height: 48.sp),
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
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.46,
                          color: mCL,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Welcome to\n',
                          ),
                          TextSpan(
                            text: 'Waterbus outsource ',
                            style: TextStyle(
                              color: colorPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.sp),
                    Text(
                      'Waterbus is a free, high-quality service for everyone to hold high-quality, '
                      'secure video calls and meetings on any phone.',
                      softWrap: true,
                      strutStyle: StrutStyle.disabled,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        height: 1.4,
                        color: colorGreyWhite,
                      ),
                    ),
                    const Spacer(),
                    ButtonLogin(
                      title: 'Continue with Google',
                      iconAsset: Assets.icons.icGoogle.path,
                      onPressed: () {},
                    ),
                    SizedBox(height: 12.sp),
                    ButtonLogin(
                      title: 'Continue with Facebook',
                      iconAsset: Assets.icons.icFacebook.path,
                      onPressed: () {},
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.sp,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              height: .25,
                              thickness: .25,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.sp),
                            child: Text(
                              'or',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: colorGreyWhite,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              height: .25,
                              thickness: .25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ButtonLogin(
                      title: 'Continue with Apple',
                      iconAsset: Assets.icons.icApple.path,
                      onPressed: () {},
                    ),
                    SizedBox(height: 20.sp),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w300,
                          color: colorGreyWhite,
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
    );
  }
}
