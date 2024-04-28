// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/helpers/extensions/duration_extensions.dart';

// Project imports:
import 'package:waterbus/core/app/lang/data/data_languages.dart';
import 'package:waterbus/features/meeting/presentation/widgets/thumbnail_widget.dart';

class ScreenSelectDialog extends StatefulWidget {
  const ScreenSelectDialog({super.key});

  @override
  State<ScreenSelectDialog> createState() => _ScreenSelectDialogState();
}

class _ScreenSelectDialogState extends State<ScreenSelectDialog> {
  final Map<String, DesktopCapturerSource> _sources = {};

  SourceType _sourceType = SourceType.Screen;

  DesktopCapturerSource? _selectedSource;

  final List<StreamSubscription<DesktopCapturerSource>> _subscriptions = [];

  StateSetter? _stateSetter;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(100.milliseconds, () {
      _getSources();
    });
    _subscriptions.add(
      desktopCapturer.onAdded.stream.listen((source) {
        _sources[source.id] = source;
        _stateSetter?.call(() {});
      }),
    );

    _subscriptions.add(
      desktopCapturer.onRemoved.stream.listen((source) {
        _sources.remove(source.id);
        _stateSetter?.call(() {});
      }),
    );

    _subscriptions.add(
      desktopCapturer.onThumbnailChanged.stream.listen((source) {
        _stateSetter?.call(() {});
      }),
    );
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _ok(context) async {
    _timer?.cancel();
    for (final element in _subscriptions) {
      element.cancel();
    }
    Navigator.pop<DesktopCapturerSource>(context, _selectedSource);
  }

  Future<void> _cancel(context) async {
    _timer?.cancel();
    for (final element in _subscriptions) {
      element.cancel();
    }
    Navigator.pop<DesktopCapturerSource>(context);
  }

  Future<void> _getSources() async {
    try {
      final sources = await desktopCapturer.getSources(types: [_sourceType]);
      for (final element in sources) {
        if (kDebugMode) {
          print(
            'name: ${element.name}, id: ${element.id}, type: ${element.type}',
          );
        }
      }
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        desktopCapturer.updateSources(types: [_sourceType]);
      });
      _sources.clear();
      for (final element in sources) {
        _sources[element.id] = element;
      }
      _stateSetter?.call(() {});
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
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
                child: StatefulBuilder(
                  builder: (context, setState) {
                    _stateSetter = setState;
                    return DefaultTabController(
                      length: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            constraints:
                                const BoxConstraints.expand(height: 24),
                            child: TabBar(
                              labelColor: Theme.of(context).primaryColor,
                              indicatorColor: Theme.of(context).primaryColor,
                              onTap: (value) =>
                                  Future.delayed(Duration.zero, () {
                                _sourceType = value == 0
                                    ? SourceType.Screen
                                    : SourceType.Window;
                                _getSources();
                              }),
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
                                  child: GridView.count(
                                    crossAxisSpacing: 8,
                                    crossAxisCount: 2,
                                    children: _sources.entries
                                        .where(
                                          (element) =>
                                              element.value.type ==
                                              SourceType.Screen,
                                        )
                                        .map(
                                          (e) => ThumbnailWidget(
                                            onTap: (source) {
                                              setState(() {
                                                _selectedSource = source;
                                              });
                                            },
                                            source: e.value,
                                            selected: _selectedSource?.id ==
                                                e.value.id,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                Align(
                                  child: GridView.count(
                                    padding: EdgeInsets.zero,
                                    crossAxisSpacing: 8.sp,
                                    crossAxisCount: 3,
                                    children: _sources.entries
                                        .where(
                                          (element) =>
                                              element.value.type ==
                                              SourceType.Window,
                                        )
                                        .map(
                                          (e) => ThumbnailWidget(
                                            onTap: (source) {
                                              setState(() {
                                                _selectedSource = source;
                                              });
                                            },
                                            source: e.value,
                                            selected: _selectedSource?.id ==
                                                e.value.id,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                    color: Theme.of(context).primaryColor,
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
