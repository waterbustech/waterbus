import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_checkbox_card.dart';

class VideoQualityBottomSheet extends StatefulWidget {
  final VideoQuality quality;
  final Function(VideoQuality) onChanged;
  const VideoQualityBottomSheet({
    super.key,
    required this.quality,
    required this.onChanged,
  });

  @override
  State<VideoQualityBottomSheet> createState() =>
      _VideoQualityBottomSheetState();
}

class _VideoQualityBottomSheetState extends State<VideoQualityBottomSheet> {
  late VideoQuality _quality = widget.quality;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 25.sp,
        horizontal: 4.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.sp),
            child: Text(
              Strings.videoQuality.i18n,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: 12.sp),
          ...List.generate(
            VideoQuality.values.length,
            (index) => SettingCheckboxCard(
              label: VideoQuality.values[index].label.i18n,
              enabled: _quality == VideoQuality.values[index],
              hasDivider: index < VideoQuality.values.length - 1,
              onTap: () {
                setState(() {
                  _quality = VideoQuality.values[index];
                });
                widget.onChanged(_quality);
              },
            ),
          ),
        ],
      ),
    );
  }
}
