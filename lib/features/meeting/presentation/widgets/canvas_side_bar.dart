import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';

import 'package:file_saver/file_saver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;
import 'package:waterbus_sdk/types/models/draw_model.dart';
import 'package:waterbus_sdk/types/models/draw_socket_event.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/domain/models/drawing_tool.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/handle_socket/drawing_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/options/drawing_options_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/color_palette.dart';

class CanvasSideBar extends StatefulWidget {
  final GlobalKey canvasGlobalKey;
  final List<DrawModel?>? historyDraw;
  final void Function()? callBackCurrentDraw;
  const CanvasSideBar({
    super.key,
    required this.canvasGlobalKey,
    this.historyDraw,
    this.callBackCurrentDraw,
  });

  @override
  State<CanvasSideBar> createState() => _CanvasSideBarState();
}

class _CanvasSideBarState extends State<CanvasSideBar> {
  final scrollController = ScrollController();
  final scrollController1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingBloc, DrawingState>(
      builder: (context, state) {
        return BlocBuilder<DrawingOptionsBloc, DrawingOptionsState>(
          builder: (context, stateOptions) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 3,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Scrollbar(
                controller: scrollController,
                scrollbarOrientation: ScrollbarOrientation.left,
                thumbVisibility: true,
                trackVisibility: true,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(10.0),
                  controller: scrollController1,
                  children: [
                    SizedBox(
                      height: 10.h,
                      width: 10.w,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            _IconBox(
                              iconData: FontAwesomeIcons.pencil,
                              selected: stateOptions.drawingTool ==
                                  DrawingTool.pencil,
                              onTap: () => AppBloc.drawingOptionsBloc.add(
                                const ChangeDrawingToolEvent(
                                  DrawingTool.pencil,
                                ),
                              ),
                              tooltip: 'Pencil',
                            ),
                            _IconBox(
                              selected:
                                  stateOptions.drawingTool == DrawingTool.line,
                              onTap: () => AppBloc.drawingOptionsBloc.add(
                                const ChangeDrawingToolEvent(DrawingTool.line),
                              ),
                              tooltip: 'Line',
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 22,
                                    height: 2,
                                    color: stateOptions.drawingTool ==
                                            DrawingTool.line
                                        ? Colors.grey[900]
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            _IconBox(
                              iconData: Icons.hexagon_outlined,
                              selected: stateOptions.drawingTool ==
                                  DrawingTool.polygon,
                              onTap: () => AppBloc.drawingOptionsBloc.add(
                                const ChangeDrawingToolEvent(
                                  DrawingTool.polygon,
                                ),
                              ),
                              tooltip: 'Polygon',
                            ),
                            _IconBox(
                              iconData: FontAwesomeIcons.eraser,
                              selected: stateOptions.drawingTool ==
                                  DrawingTool.eraser,
                              onTap: () => AppBloc.drawingOptionsBloc.add(
                                const ChangeDrawingToolEvent(
                                  DrawingTool.eraser,
                                ),
                              ),
                              tooltip: 'Eraser',
                            ),
                            _IconBox(
                              iconData: FontAwesomeIcons.square,
                              selected: stateOptions.drawingTool ==
                                  DrawingTool.square,
                              onTap: () => AppBloc.drawingOptionsBloc.add(
                                const ChangeDrawingToolEvent(
                                  DrawingTool.square,
                                ),
                              ),
                              tooltip: 'Square',
                            ),
                            _IconBox(
                              iconData: FontAwesomeIcons.circle,
                              selected: stateOptions.drawingTool ==
                                  DrawingTool.circle,
                              onTap: () => AppBloc.drawingOptionsBloc.add(
                                const ChangeDrawingToolEvent(
                                  DrawingTool.circle,
                                ),
                              ),
                              tooltip: 'Circle',
                            ),
                            _IconBox(
                              iconData: FontAwesomeIcons.ruler,
                              selected: stateOptions.showGrid,
                              onTap: () => AppBloc.drawingOptionsBloc
                                  .add(ToggleGridEvent(!stateOptions.showGrid)),
                              tooltip: 'Guide Lines',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    RotatedBox(
                      quarterTurns: -1,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 10,
                          ),
                        ),
                        child: Slider(
                          value: stateOptions.strokeSize,
                          max: 50,
                          onChanged: (val) {
                            AppBloc.drawingOptionsBloc
                                .add(ChangeStrokeSizeEvent(val));
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: stateOptions.drawingTool == DrawingTool.polygon
                          ? Row(
                              children: [
                                RotatedBox(
                                  quarterTurns: -1,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6,
                                      ),
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                        overlayRadius: 10,
                                      ),
                                    ),
                                    child: Slider(
                                      value:
                                          stateOptions.polygonSides.toDouble(),
                                      min: 3,
                                      max: 8,
                                      onChanged: (val) {
                                        AppBloc.drawingOptionsBloc.add(
                                          ChangePolygonSidesEvent(val.toInt()),
                                        );
                                      },
                                      label: '${stateOptions.polygonSides}',
                                      divisions: 5,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    ColorPalette(
                      selectedColorListenable: stateOptions.selectedColor,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: [
                            IconButton(
                              onPressed: () async {
                                final Uint8List? pngBytes = await getBytes();
                                if (pngBytes != null) saveFile(pngBytes, 'png');
                              },
                              icon: const Icon(Icons.save_alt_outlined),
                            ),
                            IconButton(
                              onPressed: state.localProps.isNotEmpty
                                  ? () => {
                                        AppBloc.drawingBloc.add(
                                          OnDrawingChangedEvent(
                                            drawingModel: state.localProps.last,
                                            action: UpdateDrawEnum.remove,
                                          ),
                                        ),
                                      }
                                  : null,
                              icon: const Icon(Icons.undo),
                            ),
                            IconButton(
                              onPressed: widget.historyDraw!.isNotEmpty &&
                                      widget.historyDraw!.length !=
                                          state.localProps.length
                                  ? () => {
                                        AppBloc.drawingBloc.add(
                                          OnDrawingChangedEvent(
                                            drawingModel: widget.historyDraw![
                                                state.localProps.length]!,
                                            action: UpdateDrawEnum.add,
                                          ),
                                        ),
                                      }
                                  : null,
                              icon: const Icon(Icons.redo),
                            ),
                            IconButton(
                              icon: const Icon(Icons.cleaning_services),
                              onPressed: () => {
                                AppBloc.drawingBloc.add(
                                  OnDrawingDeletedEvent(
                                    meetingId:
                                        AppBloc.meetingBloc.state.meeting!.id,
                                  ),
                                ),
                                widget.callBackCurrentDraw!(),
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Fill:',
                              style: TextStyle(fontSize: 8),
                            ),
                            Checkbox(
                              value: stateOptions.filled,
                              onChanged: (val) {
                                AppBloc.drawingOptionsBloc
                                    .add(ToggleFilledEvent(val ?? false));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> saveFile(Uint8List bytes, String extension) async {
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

  Future<Uint8List?> getBytes() async {
    final RenderRepaintBoundary boundary = widget.canvasGlobalKey.currentContext
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
              color: selected ? Colors.grey[900]! : Colors.grey,
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
                  color: selected ? Colors.grey[900] : Colors.grey,
                  size: 15.sp,
                ),
          ),
        ),
      ),
    );
  }
}
