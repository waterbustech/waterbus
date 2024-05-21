import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/size_not_supported.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({
    super.key,
    required this.child,
  });

  void _hideKeyboard(BuildContext context) {
    if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizerUtil.isMinimunSizeSupport
        ? const SizeNotSupportedWidget()
        : Scaffold(
            appBar: _appBar(context),
            bottomNavigationBar: _bottomNavigationBar,
            resizeToAvoidBottomInset:
                _getChildScaffold?.resizeToAvoidBottomInset ?? false,
            extendBodyBehindAppBar:
                _getChildScaffold?.extendBodyBehindAppBar ?? true,
            extendBody: true,
            body: PopScope(
              canPop: _canBackward,
              onPopInvoked: _onPopInvoked,
              child: _child(context),
            ),
          );
  }

  PreferredSizeWidget? _appBar(BuildContext context) {
    return _getChildScaffold?.appBar;
  }

  Widget? get _bottomNavigationBar {
    return _getChildScaffold?.bottomNavigationBar;
  }

  Scaffold? get _getChildScaffold =>
      child is Scaffold ? child as Scaffold : null;

  Widget _child(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: _getBody(context),
    );
  }

  Widget _getBody(BuildContext context) {
    if (child is Scaffold) {
      final Scaffold childScaffold = child as Scaffold;

      if (childScaffold.body != null) {
        return GestureDetector(
          onTap: () {
            _hideKeyboard(context);
          },
          child: childScaffold.body,
        );
      }
    }

    return GestureDetector(
      onTap: () {
        _hideKeyboard(context);
      },
      child: child,
    );
  }

  bool get _canBackward => AppNavigator.canPop;

  Future<void> _onPopInvoked(bool canPop) async {
    if (AppNavigator.currentRoute()?.startsWith(Routes.meetingRoute) ?? false) {
      AppBloc.meetingBloc.add(const LeaveMeetingEvent());
    }
  }
}
