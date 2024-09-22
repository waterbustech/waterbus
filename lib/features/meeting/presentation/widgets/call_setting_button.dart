import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';

class CallSettingButton extends StatefulWidget {
  final IconData icon;
  final String lable;
  final Function() onTap;
  final bool visible;
  final bool hasDivider;
  final bool isSwitchButton;
  final bool isSwitchEnabled;
  const CallSettingButton({
    super.key,
    required this.icon,
    required this.lable,
    required this.onTap,
    this.visible = true,
    this.hasDivider = true,
    this.isSwitchButton = false,
    this.isSwitchEnabled = false,
  });

  @override
  State<CallSettingButton> createState() => _CallSettingButtonState();
}

class _CallSettingButtonState extends State<CallSettingButton> {
  late bool _isSwitchEnabled = widget.isSwitchEnabled;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: GestureWrapper(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: widget.isSwitchButton ? 0 : 10.sp,
            horizontal: 16.sp,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: widget.hasDivider
                ? Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.5,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      size: 16.sp,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    SizedBox(width: 10.sp),
                    Text(
                      widget.lable,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              if (widget.isSwitchButton)
                Switch(
                  value: _isSwitchEnabled,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      _isSwitchEnabled = !_isSwitchEnabled;
                    });

                    AppBloc.meetingBloc.add(const ToggleSubtitleEvent());
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
