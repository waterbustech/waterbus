// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';

// Project imports:


class SearchBox extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final Function(String)? onChanged;
  final Function()? handleClear;
  const SearchBox({
    super.key,
    this.margin,
    this.onChanged,
    this.handleClear,
  });

  @override
  State<StatefulWidget> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController searchKey = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();

    searchKey.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 16.sp),
      height: 34.sp,
      child: TextFormField(
        controller: searchKey,
        style: TextStyle(
          color: mC,
          fontSize: 12.sp,
        ),
        keyboardType: TextInputType.multiline,
        minLines: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: "Create or Enter code",
          hintStyle: TextStyle(
            color: mCM,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withOpacity(.2)
              : mC,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.sp),
            borderSide: BorderSide.none,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20.sp,
            maxWidth: 36.sp,
          ),
          prefixIcon: Container(
            height: 20.sp,
            width: 36.sp,
            alignment: Alignment.center,
            child: Icon(
              PhosphorIcons.magnifying_glass_bold,
              size: 12.sp,
            ),
          ),
          suffixIcon: searchKey.text.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    if (widget.handleClear == null) {
                    } else {
                      widget.handleClear!();
                    }
                    searchKey.text = '';
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFFA4A4A4),
                  ),
                ),
        ),
        onChanged: widget.onChanged ??
            (val) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {});

              setState(() {});
            },
      ),
    );
  }
}
