import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterbus/core/constants/color_constants.dart';
import 'package:waterbus/core/utils/paginated_list_view.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
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
              child: _LogBody(
                scrollController: _controller,
                onJumpBottom: () {
                  if (_controller.hasClients) {
                    _controller.animateTo(
                      _controller.position.maxScrollExtent,
                      duration: 400.milliseconds,
                      curve: Curves.easeIn,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogBody extends StatelessWidget {
  final ScrollController scrollController;
  final Function() onJumpBottom;

  const _LogBody({
    required this.scrollController,
    required this.onJumpBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.sp),
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
              _LogButton(
                tooltip: "Scroll to the bottom",
                icon: Icons.arrow_downward_rounded,
                onTap: () => onJumpBottom.call(),
              ),
              SizedBox(width: 6.sp),
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
                controller: scrollController,
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
                itemCount: state.records.length,
                itemBuilder: (context, index) {
                  final records = state.records[index];

                  return Text(
                    "[${records.level.name}] ${records.time.toIso8601String()} ${records.loggerName}: ${records.message}",
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
        padding: EdgeInsets.symmetric(horizontal: 6.sp)
            .add(EdgeInsetsGeometry.only(bottom: 6.sp, top: 4.sp)),
        child: Icon(icon, color: mGB, size: 16.sp),
      ),
    );
  }
}
