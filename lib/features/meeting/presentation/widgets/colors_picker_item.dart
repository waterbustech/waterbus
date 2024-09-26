import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/constants/constants.dart';

class ColorsPickerItem extends StatelessWidget {
  final Function(Color) onChangeColors;
  final Color onSelectedColor;
  const ColorsPickerItem({
    super.key,
    required this.onChangeColors,
    required this.onSelectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 10.sp,
      right: 10.sp,
      child: SizedBox(
        height: 30.sp,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: availableColor.length,
          separatorBuilder: (_, __) {
            return SizedBox(width: 15.sp);
          },
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => onChangeColors(availableColor[index]),
              child: Container(
                width: 25.sp,
                height: 25.sp,
                decoration: BoxDecoration(
                  color: availableColor[index],
                  shape: BoxShape.circle,
                ),
                foregroundDecoration: BoxDecoration(
                  border: onSelectedColor == availableColor[index]
                      ? Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 0.5.h,
                        )
                      : null,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
