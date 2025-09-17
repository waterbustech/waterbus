import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/gen/assets.gen.dart';

class EmptyMeetView extends StatelessWidget {
  const EmptyMeetView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.launcherIconMac.image(
            width: context.isDesktop ? 80.sp : 60.sp,
            height: context.isDesktop ? 80.sp : 60.sp,
          ),

          SizedBox(height: 16.sp),

          // Main heading
          Text(
            "Welcome to WaterBus",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
          ),

          SizedBox(height: 12.sp),

          // Subtitle with features
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.sp),
            child: Text(
              "Open-source video conferencing platform\nbuilt for developers, by developers",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                    height: 1.5,
                  ),
            ),
          ),

          SizedBox(height: 40.sp),

          // Feature cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16.sp,
              runSpacing: 16.sp,
              children: [
                _buildFeatureCard(
                  context,
                  icon: LucideIcons.shield,
                  title: "Privacy First",
                  description: "Self-hosted & secure",
                ),
                _buildFeatureCard(
                  context,
                  icon: LucideIcons.terminal,
                  title: "Open Source",
                  description: "100% transparent",
                ),
                _buildFeatureCard(
                  context,
                  icon: LucideIcons.zap,
                  title: "Fast & Light",
                  description: "Optimized performance",
                ),
              ],
            ),
          ),

          SizedBox(height: 40.sp),

          // CTA Section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.sp),
            padding: EdgeInsets.all(24.sp),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1F2937).withValues(alpha: 0.5)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16.sp),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Help us build the future of video conferencing",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 8.sp),
                Text(
                  "Star our repository, contribute code, or sponsor the project",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                ),
                SizedBox(height: 20.sp),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // GitHub button
                    Flexible(
                      child: GestureWrapper(
                        onTap: () async {
                          await launchUrl(Uri.parse(kGithubRepo));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(8.sp),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8.sp,
                                offset: Offset(0, 2.sp),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.sp,
                            horizontal: 20.sp,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8.sp,
                            children: [
                              Icon(
                                LucideIcons.github,
                                size: 16.sp,
                                color: isDark ? Colors.black : Colors.white,
                              ),
                              Text(
                                "Star on GitHub",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color:
                                          isDark ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.sp),
                    // Sponsor button
                    Flexible(
                      child: GestureWrapper(
                        onTap: () async {
                          // Add sponsor URL here
                          await launchUrl(Uri.parse("$kGithubRepo/sponsor"));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFEC4899),
                                const Color(0xFFF97316),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8.sp),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEC4899)
                                    .withValues(alpha: 0.3),
                                blurRadius: 8.sp,
                                offset: Offset(0, 2.sp),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.sp,
                            horizontal: 20.sp,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8.sp,
                            children: [
                              Icon(
                                LucideIcons.heart,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                              Text(
                                "Sponsor",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 32.sp),

          // Footer stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat(context, "Open Source", "Apache 2.0"),
              SizedBox(width: 32.sp),
              _buildStat(context, "Community", "Growing"),
              SizedBox(width: 32.sp),
              _buildStat(context, "Support", "24/7"),
            ],
          ),

          SizedBox(height: 20.sp),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: context.isDesktop ? 180.sp : 140.sp,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.sp),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 8.sp),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 4.sp),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }
}
