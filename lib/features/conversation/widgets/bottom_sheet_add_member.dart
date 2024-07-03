import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/conversation/widgets/user_card.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';

class BottomSheetAddMember extends StatefulWidget {
  final int code;
  const BottomSheetAddMember({
    super.key,
    required this.code,
  });

  @override
  State<BottomSheetAddMember> createState() => _BottomSheetAddMemberState();
}

class _BottomSheetAddMemberState extends State<BottomSheetAddMember> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: SizerUtil.isDesktop ? 75.h : 90.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.sp,
              horizontal: 18.sp,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureWrapper(
                  onTap: () {
                    AppNavigator.pop();
                  },
                  child: Icon(
                    PhosphorIcons.x_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22.sp,
                  ),
                ),
                Text(
                  "Add Members",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(width: 22.sp),
              ],
            ),
          ),
          divider,
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 16.sp),
            decoration: ShapeDecoration(
              shape: SuperellipseShape(
                borderRadius: BorderRadius.circular(25.sp),
              ),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            height: 36.sp,
            width: 100.w,
            child: TextFormField(
              controller: _controller,
              style: TextStyle(fontSize: 12.sp),
              onChanged: (val) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 1000), () {
                  AppBloc.userBloc.add(SearchUsersEvent(keyword: val.trim()));
                });
              },
              minLines: 1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.sp,
                  vertical: 8.sp,
                ),
                hintText: Strings.search.i18n,
                hintStyle: TextStyle(fontSize: 12.sp),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.sp),
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
                    size: 14.sp,
                  ),
                ),
                suffix: GestureWrapper(
                  onTap: () {
                    _controller.clear();

                    AppBloc.userBloc.add(const SearchUsersEvent(keyword: ""));
                  },
                  child: Container(
                    height: 14.sp,
                    width: 14.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Icon(
                      PhosphorIcons.x,
                      size: 8.5.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserSearchingState) {
                return Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2.sp,
                  ),
                );
              }

              if (state is UserGetDone) {
                final List<User> searchs = state.userSearchs;

                return searchs.isEmpty || _controller.text.isEmpty
                    ? const SizedBox()
                    : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 20.sp),
                          physics: const BouncingScrollPhysics(),
                          itemCount: searchs.length,
                          itemBuilder: (context, index) => GestureWrapper(
                            onTap: () {
                              AppNavigator.pop();

                              AppBloc.chatBloc.add(
                                AddMemberEvent(
                                  code: widget.code,
                                  userId: searchs[index].id,
                                ),
                              );
                            },
                            child: UserCard(user: searchs[index]),
                          ),
                        ),
                      );
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
