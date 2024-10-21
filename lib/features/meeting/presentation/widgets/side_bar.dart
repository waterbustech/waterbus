import 'dart:math';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/types/enums/side_bar_options.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/meeting/presentation/widgets/code_editor.dart';
import 'package:waterbus/features/meeting/presentation/widgets/whiteboard_widget.dart';

class SideBar extends StatefulWidget {
  final bool isExpand;
  final Function(bool) onExpandChanged;
  final int meetingId;
  const SideBar({
    super.key,
    required this.isExpand,
    required this.onExpandChanged,
    required this.meetingId,
  });

  @override
  State<StatefulWidget> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late bool _isExpand = widget.isExpand;
  SideBarOptions? _option = SideBarOptions.code;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.sp),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.sp),
                width: min(constraints.maxWidth, 48.sp) - 8.sp,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  borderRadius: BorderRadius.circular(30.sp),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...SideBarOptions.values.map(
                      (option) => _buildButton(option: option),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: widget.isExpand
                  ? Material(
                      shape: SuperellipseShape(
                        borderRadius: BorderRadius.circular(20.sp),
                      ),
                      color: mGD,
                      clipBehavior: Clip.hardEdge,
                      child: _option == SideBarOptions.code
                          ? const CodeEditorPad()
                          : _option == SideBarOptions.paint
                              ? const WhiteBoardWidget()
                              : Container(
                                  color: Colors.transparent,
                                ),
                    )
                  : const SizedBox(),
            ),
          ],
        );
      },
    );
  }

  void _toggleSideBar({required SideBarOptions option}) {
    if (_option == option) {
      setState(() {
        _isExpand = !_isExpand;
      });

      widget.onExpandChanged(_isExpand);

      if (!_isExpand) {
        setState(() {
          _option = null;
        });
      }
    } else {
      setState(() {
        _option = option;
        _isExpand = true;
      });
    }

    widget.onExpandChanged(_isExpand);
  }

  Widget _buildButton({required SideBarOptions option}) {
    return GestureWrapper(
      onTap: () {
        _toggleSideBar(option: option);
      },
      child: Tooltip(
        message: option.label,
        child: Container(
          width: 36.sp,
          height: 36.sp,
          margin: EdgeInsets.only(
            bottom: option == SideBarOptions.values.last ? 0 : 8.sp,
          ),
          alignment: Alignment.center,
          child: Image.asset(
            option.iconAssetPath,
            height: 25.sp,
            width: 25.sp,
          ),
        ),
      ),
    );
  }
}
