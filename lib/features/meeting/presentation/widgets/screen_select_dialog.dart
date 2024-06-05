import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/features/meeting/presentation/widgets/thumbnail_widget.dart';

class ScreenSelectDialog extends StatefulWidget {
  const ScreenSelectDialog({super.key});

  @override
  State<ScreenSelectDialog> createState() => _ScreenSelectDialogState();
}

class _ScreenSelectDialogState extends State<ScreenSelectDialog> {
  final List<DesktopCapturerSource> _screenSources = [];
  final List<DesktopCapturerSource> _windowSources = [];

  final StreamController<List<DesktopCapturerSource>> _screenSourcesStream =
      StreamController.broadcast();
  final StreamController<List<DesktopCapturerSource>> _windowSourcesStream =
      StreamController.broadcast();

  DesktopCapturerSource? _selectedSource;

  SourceType _sourceType = SourceType.Screen;

  final List<StreamSubscription<DesktopCapturerSource>> _subscriptions = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _subscriptions.add(
      desktopCapturer.onAdded.stream.listen((source) {
        if (source.type == SourceType.Screen) {
          _screenSources.add(source);
          _screenSourcesStream.sink.add(_screenSources);
        } else {
          _windowSources.add(source);
          _windowSourcesStream.sink.add(_windowSources);
        }
      }),
    );

    _subscriptions.add(
      desktopCapturer.onRemoved.stream.listen((source) {
        if (source.type == SourceType.Screen) {
          _screenSources.removeWhere((d) => d.id == source.id);
          _screenSourcesStream.sink.add(_screenSources);
        } else {
          _windowSources.removeWhere((d) => d.id == source.id);
          _windowSourcesStream.sink.add(_windowSources);
        }
      }),
    );

    _getSources(_sourceType);
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _timer?.cancel();
    _screenSourcesStream.close();
    _windowSourcesStream.close();
    super.dispose();
  }

  Future<void> _ok(BuildContext context) async {
    _timer?.cancel();
    for (final element in _subscriptions) {
      element.cancel();
    }
    Navigator.pop<DesktopCapturerSource>(context, _selectedSource);
  }

  Future<void> _cancel(BuildContext context) async {
    _timer?.cancel();
    for (final element in _subscriptions) {
      element.cancel();
    }
    Navigator.pop<DesktopCapturerSource>(context);
  }

  Future<void> _getSources(SourceType type) async {
    try {
      _timer?.cancel();
      final sources = await desktopCapturer.getSources(types: [type]);

      _windowSources.clear();
      _screenSources.clear();

      if (type == SourceType.Screen) {
        _screenSources.addAll(sources);
        _screenSourcesStream.sink.add(_screenSources);
      } else {
        _windowSources.addAll(sources);
        _windowSourcesStream.sink.add(_windowSources);
      }

      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        desktopCapturer.updateSources(types: [type]);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: SuperellipseShape(
        borderRadius: BorderRadius.circular(30.sp),
      ),
      child: Container(
        width: 400.sp,
        height: 450.sp,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      Strings.chooseWhatToShare.i18n,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      child: const Icon(Icons.close),
                      onTap: () => _cancel(context),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.sp),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      Container(
                        constraints: const BoxConstraints.expand(height: 24),
                        child: TabBar(
                          labelColor: Theme.of(context).colorScheme.primary,
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          onTap: (value) {
                            _sourceType = value == 0
                                ? SourceType.Screen
                                : SourceType.Window;

                            Future.delayed(300.milliseconds, () async {
                              await _getSources(_sourceType);
                            });
                          },
                          tabs: [
                            Tab(
                              child: Text(
                                Strings.entireScreen.i18n,
                              ),
                            ),
                            Tab(
                              child: Text(
                                Strings.window.i18n,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      SizedBox(height: 2.sp),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: StreamBuilder<List<DesktopCapturerSource>>(
                                stream: _screenSourcesStream.stream,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox();
                                  }

                                  return GridView.count(
                                    crossAxisSpacing: 8,
                                    crossAxisCount: 2,
                                    children: snapshot.data!
                                        .map(
                                          (e) => ThumbnailWidget(
                                            onTap: (source) {
                                              setState(() {
                                                _selectedSource = source;
                                              });
                                            },
                                            source: e,
                                            selected:
                                                _selectedSource?.id == e.id,
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                            ),
                            Align(
                              child: StreamBuilder<List<DesktopCapturerSource>>(
                                stream: _windowSourcesStream.stream,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox();
                                  }

                                  return GridView.count(
                                    padding: EdgeInsets.zero,
                                    crossAxisSpacing: 8.sp,
                                    crossAxisCount: 3,
                                    children: snapshot.data!
                                        .map(
                                          (e) => ThumbnailWidget(
                                            onTap: (source) {
                                              setState(() {
                                                _selectedSource = source;
                                              });
                                            },
                                            source: e,
                                            selected:
                                                _selectedSource?.id == e.id,
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ButtonBar(
                children: <Widget>[
                  MaterialButton(
                    shape: SuperellipseShape(
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Text(
                      Strings.cancel.i18n,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    onPressed: () {
                      _cancel(context);
                    },
                  ),
                  MaterialButton(
                    shape: SuperellipseShape(
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      Strings.share.i18n,
                    ),
                    onPressed: () {
                      _ok(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
