// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/domain/entities/beauty_filters.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/presentation/bloc/bloc/beauty_filters_bloc.dart';

class BeautyFilterWidget extends StatefulWidget {
  final Participant? participant;
  final CallState? callState;
  const BeautyFilterWidget({super.key, this.callState, this.participant});

  @override
  State<StatefulWidget> createState() => _BeautyFilterWidgetState();
}

class _BeautyFilterWidgetState extends State<BeautyFilterWidget> {
  late final BeautyFilters _beautyFilters;

  @override
  void initState() {
    super.initState();

    _beautyFilters = AppBloc.beautyFiltersBloc.filters.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 26.sp),
          _buildSliderButton(
            "Smooth",
            _beautyFilters.smoothValue,
            (value) {
              setState(() {
                _beautyFilters.smoothValue = value;
              });
            },
          ),
          _buildSliderButton(
            "White",
            _beautyFilters.whiteValue,
            (value) {
              setState(() {
                _beautyFilters.whiteValue = value;
              });
            },
          ),
          _buildSliderButton(
            "Thin Face",
            _beautyFilters.thinFaceValue * 10,
            (value) {
              setState(() {
                _beautyFilters.thinFaceValue = value / 10;
              });
            },
          ),
          _buildSliderButton(
            "Big Eyes",
            _beautyFilters.bigEyeValue * 5,
            (value) {
              setState(() {
                _beautyFilters.bigEyeValue = value / 5;
              });
            },
          ),
          _buildSliderButton(
            "Lipstick",
            _beautyFilters.lipstickValue,
            (value) {
              setState(() {
                _beautyFilters.lipstickValue = value;
              });
            },
          ),
          _buildSliderButton(
            "Blusher",
            _beautyFilters.blusherValue,
            (value) {
              setState(() {
                _beautyFilters.blusherValue = value;
              });
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
          activeColor: Theme.of(context).primaryColor,
          onChanged: (val) {
            onChanged(val);
            _update();
          },
        ),
      ],
    );
  }

  void _update() {
    AppBloc.beautyFiltersBloc.add(
      UpdateFiltersValueEvent(filters: _beautyFilters),
    );
  }
}
