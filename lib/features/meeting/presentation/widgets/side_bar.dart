// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/meeting/presentation/widgets/code_editor.dart';
import 'package:waterbus/gen/assets.gen.dart';

enum SideBarOptions {
  code,
  paint;

  const SideBarOptions();
}

class SideBar extends StatefulWidget {
  final bool isExpand;
  final Function(bool) onExpandChanged;
  const SideBar({
    super.key,
    required this.isExpand,
    required this.onExpandChanged,
  });

  @override
  State<StatefulWidget> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late bool _isExpand = widget.isExpand;
  SideBarOptions? _option = SideBarOptions.code;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.sp),
          child: Material(
            shape: SuperellipseShape(
              borderRadius: BorderRadius.circular(14.sp),
            ),
            color: Colors.grey.shade900,
            child: SizedBox(
              width: 40.sp,
              child: Column(
                children: [
                  SizedBox(height: 12.sp),
                  ...SideBarOptions.values.map(
                    (option) => _buildButton(option: option),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: widget.isExpand
              ? Material(
                  shape: SuperellipseShape(
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  color: Colors.grey.shade900,
                  clipBehavior: Clip.hardEdge,
                  child: _option == SideBarOptions.code
                      ? const CodeEditorPad()
                      : Container(
                          color: Colors.transparent,
                        ),
                )
              : const SizedBox(),
        ),
      ],
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
      child: Material(
        shape: SuperellipseShape(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        color: _option == option
            ? Theme.of(context).primaryColor
            : Colors.transparent,
        child: Container(
          width: 32.sp,
          height: 32.sp,
          alignment: Alignment.center,
          child: Image.asset(
            option == SideBarOptions.code
                ? Assets.icons.code.path
                : Assets.icons.paintBoard.path,
            height: 20.sp,
            width: 20.sp,
            color: mC,
          ),
        ),
      ),
    );
  }
}
