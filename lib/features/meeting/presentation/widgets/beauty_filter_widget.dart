// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meet_view.dart';

class BeautyFilterWidget extends StatefulWidget {
  final Participant participant;
  final CallState? callState;
  const BeautyFilterWidget({
    super.key,
    required this.callState,
    required this.participant,
  });

  @override
  State<StatefulWidget> createState() => _BeautyFilterWidgetState();
}

class _BeautyFilterWidgetState extends State<BeautyFilterWidget> {
  double _thinFaceValue = 0;
  double _smoothFaceValue = 0;
  double _bigEyesValue = 0;
  double _lipstickValue = 0;
  double _whiteFaceValue = 0;
  double _blusherValue = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.sp),
          Container(
            height: SizerUtil.isDesktop ? 40.w * (1 / 2.5) : 100.w * (9 / 16),
            margin: EdgeInsets.symmetric(horizontal: 12.sp),
            child: MeetView(
              participant: widget.participant,
              callState: widget.callState,
              radius: BorderRadius.circular(20.sp),
            ),
          ),
          SizedBox(height: 12.sp),
          _buildSliderButton(
            "Smooth",
            _smoothFaceValue,
            (value) {
              setState(() {
                _smoothFaceValue = value;
              });

              Helper.setSmoothValue(value / 10);
            },
          ),
          _buildSliderButton(
            "White",
            _whiteFaceValue,
            (value) {
              setState(() {
                _whiteFaceValue = value;
              });

              Helper.setWhiteValue(value / 10);
            },
          ),
          _buildSliderButton(
            "Thin Face",
            _thinFaceValue,
            (value) {
              setState(() {
                _thinFaceValue = value;
              });

              Helper.setThinFaceValue(value / 100);
            },
          ),
          _buildSliderButton(
            "Big Eyes",
            _bigEyesValue,
            (value) {
              setState(() {
                _bigEyesValue = value;
              });

              Helper.setBigEyeValue(value / 50);
            },
          ),
          _buildSliderButton(
            "Lipstick",
            _lipstickValue,
            (value) {
              setState(() {
                _lipstickValue = value;
              });

              Helper.setLipstickValue(value / 10);
            },
          ),
          _buildSliderButton(
            "Blusher",
            _blusherValue,
            (value) {
              setState(() {
                _blusherValue = value;
              });

              Helper.setBlusherValue(value / 10);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSliderButton(
    String label,
    double value,
    Function(double) onChanged,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 11.sp,
              ),
        ),
        Slider(
          value: value,
          max: 10.0,
          activeColor: Theme.of(context).primaryColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
