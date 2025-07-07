import 'package:flutter/material.dart';

import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/size_not_supported.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({
    super.key,
    required this.child,
  });

  void _hideKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return SizerUtils.instance.isMinimunSizeSupport
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
              onPopInvokedWithResult: _onPopInvoked,
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
          onTap: (FocusManager.instance.primaryFocus?.hasFocus ?? false)
              ? () {
                  _hideKeyboard(context);
                }
              : null,
          child: childScaffold.body,
        );
      }
    }

    return GestureDetector(
      onTap: (FocusManager.instance.primaryFocus?.hasFocus ?? false)
          ? () {
              _hideKeyboard(context);
            }
          : null,
      child: child,
    );
  }

  bool get _canBackward => AppRouter.canPop;

  void _onPopInvoked(bool canPop, _) {
    // if (AppRouter.instance.currentRoute.startsWith(Routes.roomRoute)) {
    //   AppBloc.roomBloc.add(const RoomLeft());
    // }
  }
}
