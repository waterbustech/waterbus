import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:waterbus/core/constants/color_constants.dart';
import 'package:waterbus/core/utils/paginated_list_view.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/drop_down/drop_down_button.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';
import 'package:waterbus/features/home/domain/entities/log_record_extension.dart';
import 'package:waterbus/features/home/presentation/bloc/logger/logger_bloc.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

class LoggerWidget extends StatefulWidget {
  const LoggerWidget({super.key});

  @override
  State<LoggerWidget> createState() => LoggerWidgetState();
}

class LoggerWidgetState extends State<LoggerWidget> {
  final ScrollController _controller = ScrollController();

  static const double _minExtent = 0.1;
  static const double _midExtent = 0.5;
  static const double _maxExtent = 0.9;

  double _extent = _midExtent;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: 150.milliseconds,
        curve: Curves.easeOut,
        height: MediaQuery.of(context).size.height * _extent,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.resizeUpDown,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    _extent = _maxExtent;
                  });
                },
                onVerticalDragUpdate: (d) {
                  final double height = MediaQuery.of(context).size.height;
                  final double delta = d.delta.dy / height;

                  setState(() {
                    _extent = (_extent - delta).clamp(_minExtent, _maxExtent);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5.sp),
                  child: Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 1.sp,
                  ),
                ),
              ),
            ),
            Expanded(
              child: IgnorePointer(
                ignoring: false,
                child: _LocalNavigator(
                  child: _LogBody(scrollController: _controller),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogBody extends StatefulWidget {
  final ScrollController scrollController;

  const _LogBody({
    required this.scrollController,
  });

  @override
  State<_LogBody> createState() => _LogBodyState();
}

class _LogBodyState extends State<_LogBody> {
  final TextEditingController _filterController = TextEditingController();
  Timer? _debounce;
  Level? _level;

  @override
  void initState() {
    super.initState();
    _filterController.text = AppBloc.loggerBloc.keyword;
    _level = AppBloc.loggerBloc.level;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 32.sp,
          padding: EdgeInsets.symmetric(horizontal: 12.sp)
              .add(EdgeInsetsGeometry.only(bottom: 4.sp)),
          child: Row(
            children: [
              Text(
                "Console",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontSize: 11.sp,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 25.w,
                child: TextFieldInput(
                  margin: EdgeInsets.zero,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.5.sp,
                    horizontal: 4.sp,
                  ),
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 8.5.sp,
                    color: Theme.of(context).textTheme.titleSmall!.color,
                  ),
                  borderRadius: BorderRadius.circular(4.sp),
                  controller: _filterController,
                  validatorForm: (val) => null,
                  onChanged: (val) {
                    if (_debounce?.isActive ?? false) {
                      _debounce?.cancel();
                    }

                    _debounce = Timer(
                      400.milliseconds,
                      () {
                        AppBloc.loggerBloc.add(LoggerFilterEvent(keyword: val));
                      },
                    );
                  },
                  hintText: 'Filter',
                ),
              ),
              SizedBox(width: 10.sp),
              Container(
                width: 12.w,
                margin: EdgeInsets.symmetric(vertical: 3.sp),
                padding: EdgeInsets.symmetric(horizontal: 6.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.sp),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: showDropdownButton<Level>(
                  width: 12.w,
                  menuHeight: 24.sp,
                  data: Level.LEVELS,
                  offset: const Offset(-8, -4),
                  onChanged: (val) {
                    setState(() {
                      if (_level == val) {
                        _level = null;
                      } else {
                        _level = val;
                      }
                    });

                    AppBloc.loggerBloc.add(
                      LoggerFilterEvent(
                        keyword: _filterController.text,
                        level: _level,
                      ),
                    );
                  },
                  currentData: _level,
                  hint: Text(
                    'Select level',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  items: Level.LEVELS
                      .map(
                        (item) => DropdownMenuItem<Level>(
                          value: item,
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 9.sp,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(width: 10.sp),
              _LogButton(
                tooltip: "Delete",
                icon: Icons.delete_outline_rounded,
                onTap: () {
                  AppBloc.loggerBloc.add(LoggerClearEvent());
                },
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white12, height: 1),
        Expanded(
          child: BlocBuilder<LoggerBloc, LoggerState>(
            builder: (context, state) {
              return PaginatedListView(
                controller: widget.scrollController,
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
                itemCount: state.records.length,
                itemBuilder: (context, index) {
                  final records = state.records[index];

                  return Text(
                    records.label,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: records.leverColor,
                    ),
                  );
                },
                childShimmer: SizedBox(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LogButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Function? onTap;

  const _LogButton({
    required this.tooltip,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 4.sp),
        child: Icon(icon, color: mGB, size: 17.sp),
      ),
    );
  }
}

class _LocalNavigator extends StatelessWidget {
  final Widget child;
  const _LocalNavigator({required this.child});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => child,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        opaque: false,
      ),
    );
  }
}
