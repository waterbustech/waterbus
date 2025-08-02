import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';

class VirtualBackgroundInRoom extends StatefulWidget {
  final Function onClosePressed;
  const VirtualBackgroundInRoom({
    super.key,
    required this.onClosePressed,
  });

  @override
  State<VirtualBackgroundInRoom> createState() =>
      _VirtualBackgroundInRoomState();
}

class _VirtualBackgroundInRoomState extends State<VirtualBackgroundInRoom> {
  String? _currentBackground;

  @override
  void initState() {
    super.initState();

    _currentBackground = AppBloc.roomBloc.currentBackground;
  }

  List<String> get backgroundAssets =>
      context.isDesktop ? desktopBackgrounds : backgrounds;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.sp),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceDim.withValues(
                alpha: 0.25,
              ),
          borderRadius: BorderRadius.circular(2.sp),
        ),
        padding: EdgeInsets.all(4.sp),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Background",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureWrapper(
                    onTap: () {
                      widget.onClosePressed();
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 18.sp,
                      width: 18.sp,
                      child: Icon(
                        PhosphorIcons.x(),
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2.sp,
                ),
                itemCount: backgroundAssets.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureWrapper(
                      onTap: () {
                        setState(() {
                          _currentBackground = null;
                        });

                        AppBloc.roomBloc.add(
                          RoomVirtualBackgroundApplied(_currentBackground),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                            color: _currentBackground == null
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).dividerColor,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.block,
                          size: 20.sp,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    );
                  }

                  return GestureWrapper(
                    onTap: () {
                      setState(() {
                        _currentBackground = backgroundAssets[index - 1];
                      });

                      AppBloc.roomBloc.add(
                        RoomVirtualBackgroundApplied(_currentBackground),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.sp,
                          color:
                              _currentBackground == backgroundAssets[index - 1]
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Image.asset(
                        backgroundAssets[index - 1],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
