import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';

import 'package:file_saver/file_saver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus_sdk/types/enums/draw_shapes.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/whiteboard/whiteboard_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/color_palette.dart';

class CanvasSideBar extends StatelessWidget {
  final GlobalKey canvasGlobalKey;
  final List<DrawModel?>? historyDraw;
  const CanvasSideBar({
    super.key,
    required this.canvasGlobalKey,
    this.historyDraw,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhiteBoardBloc, WhiteBoardState>(
      builder: (context, state) {
        return Container(
          height: 90.sp,
          width: 50.w,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 3,
                offset: const Offset(3, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40.sp,
                padding: EdgeInsets.only(left: 16.sp),
                child: Wrap(
                  direction: Axis.vertical,
                  runAlignment: WrapAlignment.center,
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    _IconBox(
                      iconData: PhosphorIcons.pencil,
                      selected:
                          state.currentPaint.drawShapes == DrawShapes.normal,
                      onTap: () => AppBloc.whiteBoardBloc.add(
                        ChangeDrawShapesEvent(
                          DrawShapes.normal,
                        ),
                      ),
                      tooltip: 'Pencil',
                    ),
                    _IconBox(
                      iconData: PhosphorIcons.eraser,
                      selected:
                          state.currentPaint.drawShapes == DrawShapes.eraser,
                      onTap: () => AppBloc.whiteBoardBloc.add(
                        ChangeDrawShapesEvent(
                          DrawShapes.eraser,
                        ),
                      ),
                      tooltip: 'Eraser',
                    ),
                  ],
                ),
              ),
              _verticalDivider,
              SizedBox(
                width: 10.w,
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    _IconBox(
                      selected:
                          state.currentPaint.drawShapes == DrawShapes.line,
                      onTap: () => AppBloc.whiteBoardBloc.add(
                        ChangeDrawShapesEvent(DrawShapes.line),
                      ),
                      tooltip: 'Line',
                      iconData: PhosphorIcons.minus,
                    ),
                    _IconBox(
                      iconData: Icons.hexagon_outlined,
                      selected:
                          state.currentPaint.drawShapes == DrawShapes.polygon,
                      onTap: () => AppBloc.whiteBoardBloc.add(
                        ChangeDrawShapesEvent(
                          DrawShapes.polygon,
                        ),
                      ),
                      tooltip: 'Polygon',
                    ),
                    _IconBox(
                      iconData: PhosphorIcons.square,
                      selected:
                          state.currentPaint.drawShapes == DrawShapes.square,
                      onTap: () => AppBloc.whiteBoardBloc.add(
                        ChangeDrawShapesEvent(
                          DrawShapes.square,
                        ),
                      ),
                      tooltip: 'Square',
                    ),
                    _IconBox(
                      iconData: PhosphorIcons.circle,
                      selected:
                          state.currentPaint.drawShapes == DrawShapes.circle,
                      onTap: () => AppBloc.whiteBoardBloc.add(
                        ChangeDrawShapesEvent(
                          DrawShapes.circle,
                        ),
                      ),
                      tooltip: 'Circle',
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.sp,
                child: RotatedBox(
                  quarterTurns: -1,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      overlayColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Colors.grey,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 10,
                      ),
                    ),
                    child: Slider(
                      value: state.currentPaint.size,
                      max: 50,
                      onChanged: (val) {
                        AppBloc.whiteBoardBloc.add(ChangeStrokeSizeEvent(val));
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.sp),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: state.currentPaint.drawShapes == DrawShapes.polygon
                    ? Row(
                        children: [
                          RotatedBox(
                            quarterTurns: -1,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                overlayColor:
                                    Theme.of(context).colorScheme.primary,
                                activeTrackColor:
                                    Theme.of(context).colorScheme.primary,
                                inactiveTrackColor: Colors.grey,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 10,
                                ),
                              ),
                              child: Slider(
                                value:
                                    state.currentPaint.polygonSides.toDouble(),
                                min: 3,
                                max: 8,
                                onChanged: (val) {
                                  AppBloc.whiteBoardBloc.add(
                                    ChangePolygonSidesEvent(val.toInt()),
                                  );
                                },
                                label: '${state.currentPaint.polygonSides}',
                                divisions: 5,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              _verticalDivider,
              SizedBox(
                width: 280.sp,
                child: ColorPalette(
                  selectedColorListenable: state.currentPaint.color,
                ),
              ),
              _verticalDivider,
              SizedBox(
                width: 150.sp,
                child: Wrap(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final Uint8List? pngBytes = await _getBytes();
                        if (pngBytes != null) _saveFile(pngBytes, 'png');
                      },
                      icon: const Icon(PhosphorIcons.floppy_disk),
                    ),
                    IconButton(
                      onPressed: () => AppBloc.whiteBoardBloc.add(
                        OnUndoEvent(),
                      ),
                      icon: const Icon(PhosphorIcons.arrow_u_up_left),
                    ),
                    IconButton(
                      onPressed: () => AppBloc.whiteBoardBloc.add(
                        OnRedoEvent(),
                      ),
                      icon: const Icon(PhosphorIcons.arrow_u_up_right),
                    ),
                    IconButton(
                      icon: const Icon(PhosphorIcons.trash_simple),
                      onPressed: () => {
                        AppBloc.whiteBoardBloc.add(
                          CleanWhiteBoardEvent(
                            meetingId: AppBloc.meetingBloc.state.meeting!.id,
                          ),
                        ),
                      },
                    ),
                    IconButton(
                      onPressed: () => AppBloc.whiteBoardBloc.add(
                        ToggleFilledEvent(!state.currentPaint.isFilled),
                      ),
                      icon: Icon(
                        state.currentPaint.isFilled
                            ? PhosphorIcons.paint_bucket_fill
                            : PhosphorIcons.paint_bucket,
                      ),
                    ),
                    IconButton(
                      onPressed: () => AppBloc.whiteBoardBloc.add(
                        ToggleGridEvent(!state.currentPaint.showGrid),
                      ),
                      icon: Icon(
                        state.currentPaint.showGrid
                            ? PhosphorIcons.ruler_fill
                            : PhosphorIcons.ruler,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget get _verticalDivider => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.sp),
        child: VerticalDivider(color: mGB, width: 3),
      );

  Future<void> _saveFile(Uint8List bytes, String extension) async {
    if (kIsWeb) {
      html.AnchorElement()
        ..href = '${Uri.dataFromBytes(bytes, mimeType: 'image/$extension')}'
        ..download =
            'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension'
        ..style.display = 'none'
        ..click();
    } else {
      await FileSaver.instance.saveFile(
        name: 'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension',
        bytes: bytes,
        ext: extension,
        mimeType: MimeType.png,
      );
    }
  }

  Future<Uint8List?> _getBytes() async {
    final RenderRepaintBoundary boundary = canvasGlobalKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? pngBytes = byteData?.buffer.asUint8List();
    return pngBytes;
  }
}

class _IconBox extends StatelessWidget {
  final IconData? iconData;
  final Widget? child;
  final bool selected;
  final VoidCallback onTap;
  final String? tooltip;

  const _IconBox({
    this.iconData,
    this.child,
    this.tooltip,
    required this.selected,
    required this.onTap,
  }) : assert(child != null || iconData != null);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 25.sp,
          width: 25.sp,
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              width: 1.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Tooltip(
            message: tooltip,
            preferBelow: false,
            child: child ??
                Icon(
                  iconData,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  size: 15.sp,
                ),
          ),
        ),
      ),
    );
  }
}
