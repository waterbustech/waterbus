// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;

  const AppScaffold({
    super.key,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> with WidgetsBindingObserver {
  final List<String> _ignoreRotateEvent = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_ignoreRotateEvent.contains(AppNavigator.currentRoute())) return;
  }

  _hideKeyboard() {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return SafeArea(
          top: false,
          bottom: false,
          child: !kIsWeb && Platform.isIOS
              ? _child
              : PopScope(
                  canPop: _canPop(),
                  onPopInvoked: _onPopInvoked,
                  child: _child,
                ),
        );
      },
    );
  }

  Widget get _child {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: _getBody,
    );
  }

  Widget get _getBody {
    return GestureDetector(
      onHorizontalDragUpdate: kIsWeb ? null : Platform.isAndroid ||
              [].contains(AppNavigator.currentRoute())
          ? null
          : (details) async {
              // Cannot back when at ROOT, EDIT_PHOTO and Connecting Call
              if (Platform.isIOS && ![].contains(AppNavigator.currentRoute())) {
                //set the sensitivity for your ios gesture anywhere between 10-50 is good

                const int sensitivity = 15;

                if (details.delta.dx > sensitivity) {
                  //SWIPE FROM RIGHT DETECTION
                  final bool canBackward = _canPop();
                  if (canBackward) {
                    AppNavigator.pop();
                  }
                }
              }
            },
      onTap: () => _hideKeyboard(),
      child: widget.child,
    );
  }

  void _onPopInvoked(bool canPop) {
    if (Routes.meetingRoute == AppNavigator.currentRoute()) {
      AppBloc.meetingBloc.add(const LeaveMeetingEvent());
    }
  }

  bool _canPop() => true;
}
