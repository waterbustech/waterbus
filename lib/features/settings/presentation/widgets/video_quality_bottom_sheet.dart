// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/models/index.dart';

// Project imports:
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
        horizontal: 16.sp,
        vertical: 25.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Video Quality',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 12.sp),
          ...List.generate(
            VideoQuality.values.length,
            (index) => SettingCheckboxCard(
              label: VideoQuality.values[index].label,
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
