// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

class SettingSwitchCard extends StatefulWidget {
  final String label;
  final bool enabled;
  final Function(bool) onChanged;
  final bool hasDivider;
  final String? value;
  const SettingSwitchCard({
    super.key,
    required this.label,
    required this.enabled,
    required this.onChanged,
    this.hasDivider = true,
    this.value,
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
      padding: EdgeInsets.symmetric(vertical: 4.sp),
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
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
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
