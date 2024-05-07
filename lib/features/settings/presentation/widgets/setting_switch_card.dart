// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

class SettingSwitchCard extends StatefulWidget {
  final String label;
  final Function(bool) onChanged;
  final String? value;
  final IconData? icon;
  final bool enabled;
  final bool hasDivider;
  final bool readonly;
  const SettingSwitchCard({
    super.key,
    required this.label,
    required this.enabled,
    required this.onChanged,
    this.hasDivider = true,
    this.readonly = false,
    this.value,
    this.icon,
  });

  @override
  State<SettingSwitchCard> createState() => _SettingSwitchCardState();
}

class _SettingSwitchCardState extends State<SettingSwitchCard> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: widget.hasDivider
            ? Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              )
            : null,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 12.sp,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 4.sp,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
          ),
          widget.value != null
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Text(
                    widget.value!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12.sp,
                        ),
                  ),
                )
              : Switch(
                  value: _isEnabled,
                  activeColor: Theme.of(context).colorScheme.primary,
                  thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                    (states) {
                      if (states.contains(MaterialState.selected)) {
                        return Icon(
                          widget.icon,
                          color: Colors.grey.shade100,
                        );
                      }

                      return null;
                    },
                  ),
                  onChanged: (value) {
                    if (widget.readonly) return;

                    setState(() {
                      _isEnabled = value;
                    });

                    widget.onChanged(value);
                  },
                ),
        ],
      ),
    );
  }
}
