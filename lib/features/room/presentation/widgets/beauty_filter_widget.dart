import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/room/presentation/bloc/beauty_filters/beauty_filters_bloc.dart';
import 'package:waterbus/gen/assets.gen.dart';
import 'package:waterbus/gen/fonts.gen.dart';

class BeautyFilterWidget extends StatefulWidget {
  final Participant? participant;
  final CallState? callState;
  final Function? handleClosed;
  const BeautyFilterWidget({
    super.key,
    this.callState,
    this.participant,
    this.handleClosed,
  });

  @override
  State<StatefulWidget> createState() => _BeautyFilterWidgetState();
}

class _BeautyFilterWidgetState extends State<BeautyFilterWidget> {
  late BeautyFilters _beautyFilters;

  @override
  void initState() {
    super.initState();

    _beautyFilters = AppBloc.beautyFiltersBloc.filters.copyWith.call();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.sp),
          if (context.isDesktop)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => widget.handleClosed?.call(),
                  icon: Icon(
                    PhosphorIcons.x(),
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Lottie.asset(
                    Assets.lotties.beautyFiltersLottie,
                    width: constraints.maxWidth * 0.2,
                    fit: BoxFit.contain,
                    frameRate: FrameRate.max,
                    repeat: true,
                  ),
                  SizedBox(width: 24.sp),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: constraints.maxWidth * 0.06,
                        fontFamily: FontFamily.pixelify,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Beauty',
                          style: TextStyle(
                            color: Color(0xFFEFB7E9),
                          ),
                        ),
                        TextSpan(
                          text: '\t\tFilters',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          _buildSliderButton(
            Strings.smooth.i18n,
            _beautyFilters.smoothValue * 10,
            (value) {
              setState(() {
                _beautyFilters =
                    _beautyFilters.copyWith(smoothValue: value / 10);
              });
            },
          ),
          _buildSliderButton(
            Strings.white.i18n,
            _beautyFilters.whiteValue * 20,
            (value) {
              setState(() {
                _beautyFilters =
                    _beautyFilters.copyWith(whiteValue: value / 20);
              });
            },
          ),
          _buildSliderButton(
            Strings.thinFace.i18n,
            _beautyFilters.thinFaceValue * 200,
            (value) {
              setState(() {
                _beautyFilters =
                    _beautyFilters.copyWith(thinFaceValue: value / 200);
              });
            },
          ),
          _buildSliderButton(
            Strings.bigEyes.i18n,
            _beautyFilters.bigEyeValue * 100,
            (value) {
              setState(() {
                _beautyFilters =
                    _beautyFilters.copyWith(bigEyeValue: value / 100);
              });
            },
          ),
          _buildSliderButton(
            Strings.lipstick.i18n,
            _beautyFilters.lipstickValue * 10,
            (value) {
              setState(() {
                _beautyFilters =
                    _beautyFilters.copyWith(lipstickValue: value / 10);
              });
            },
          ),
          _buildSliderButton(
            Strings.blusher.i18n,
            _beautyFilters.blusherValue * 10,
            (value) {
              setState(() {
                _beautyFilters =
                    _beautyFilters.copyWith(blusherValue: value / 10);
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
          max: 10,
          value: value,
          activeColor: Theme.of(context).colorScheme.primary,
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
      BeautyFilterUpdated(filters: _beautyFilters),
    );
  }
}
