// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/lang/data/data_languages.dart';

// Project imports:
import 'package:waterbus/features/profile/presentation/fake/menu_items.dart';

class MenuDrawerCard extends StatelessWidget {
  final MenuItemModel item;
  const MenuDrawerCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 12.sp),
      child: Row(
        children: [
          Image.asset(
            item.iconAssetPath,
            width: SizerUtil.isDesktop ? 22.sp : 18.5.sp,
            height: SizerUtil.isDesktop ? 22.sp : 18.5.sp,
          ),
          SizedBox(width: 10.sp),
          Text(
            item.title.i18n,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
