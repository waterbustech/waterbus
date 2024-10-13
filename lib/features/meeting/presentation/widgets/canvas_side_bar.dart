import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:file_saver/file_saver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingBloc, DrawingState>(
      builder: (context, state) {
        return BlocBuilder<DrawingOptionsBloc, DrawingOptionsState>(
          builder: (context, stateOptions) {
            return Container(
              width: 300,
              height: MediaQuery.of(context).size.height < 680 ? 450 : 610,
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
                thumbVisibility: true,
                trackVisibility: true,
                child: ListView(
                  padding: const EdgeInsets.all(10.0),
                  controller: scrollController,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Shapes',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        _IconBox(
                          iconData: FontAwesomeIcons.pencil,
                          selected:
                              stateOptions.drawingTool == DrawingTool.pencil,
                          onTap: () => AppBloc.drawingOptionsBloc.add(
                            const ChangeDrawingToolEvent(DrawingTool.pencil),
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
                                color:
                                    stateOptions.drawingTool == DrawingTool.line
                                        ? Colors.grey[900]
                                        : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        _IconBox(
                          iconData: Icons.hexagon_outlined,
                          selected:
                              stateOptions.drawingTool == DrawingTool.polygon,
                          onTap: () => AppBloc.drawingOptionsBloc.add(
                            const ChangeDrawingToolEvent(DrawingTool.polygon),
                          ),
                          tooltip: 'Polygon',
                        ),
                        _IconBox(
                          iconData: FontAwesomeIcons.eraser,
                          selected:
                              stateOptions.drawingTool == DrawingTool.eraser,
                          onTap: () => AppBloc.drawingOptionsBloc.add(
                            const ChangeDrawingToolEvent(DrawingTool.eraser),
                          ),
                          tooltip: 'Eraser',
                        ),
                        _IconBox(
                          iconData: FontAwesomeIcons.square,
                          selected:
                              stateOptions.drawingTool == DrawingTool.square,
                          onTap: () => AppBloc.drawingOptionsBloc.add(
                            const ChangeDrawingToolEvent(DrawingTool.square),
                          ),
                          tooltip: 'Square',
                        ),
                        _IconBox(
                          iconData: FontAwesomeIcons.circle,
                          selected:
                              stateOptions.drawingTool == DrawingTool.circle,
                          onTap: () => AppBloc.drawingOptionsBloc.add(
                            const ChangeDrawingToolEvent(DrawingTool.circle),
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Fill Shape: ',
                          style: TextStyle(fontSize: 12),
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

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: stateOptions.drawingTool == DrawingTool.polygon
                          ? Row(
                              children: [
                                const Text(
                                  'Polygon Sides: ',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Slider(
                                  value: stateOptions.polygonSides.toDouble(),
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
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Colors',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    ColorPalette(
                      selectedColorListenable: stateOptions.selectedColor,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Size',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Text(
                          'Stroke Size: ',
                          style: TextStyle(fontSize: 12),
                        ),
                        Slider(
                          value: stateOptions.strokeSize,
                          max: 50,
                          onChanged: (val) {
                            AppBloc.drawingOptionsBloc
                                .add(ChangeStrokeSizeEvent(val));
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Eraser Size: ',
                          style: TextStyle(fontSize: 12),
                        ),
                        Slider(
                          value: stateOptions.eraserSize,
                          max: 80,
                          onChanged: (val) {
                            AppBloc.drawingOptionsBloc
                                .add(ChangeEraserSizeEvent(val));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Wrap(
                      children: [
                        TextButton(
                          onPressed: state.localProps.isNotEmpty
                              ? () => {
                                    AppBloc.drawingBloc.add(
                                      OnDrawingChangedEvent(
                                        drawingModel: state.localProps.last,
                                        action: UpdateDrawEnum.remove,
                                      ),
                                    ),
                                    state.localProps.removeLast(),
                                  }
                              : null,
                          child: const Text('Undo'),
                        ),
                        TextButton(
                          onPressed: widget.historyDraw!.isNotEmpty &&
                                  widget.historyDraw!.length ==
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
                          child: const Text('Redo'),
                        ),
                        TextButton(
                          child: const Text('Clear'),
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
                    const SizedBox(height: 20),
                    const Text(
                      'Export',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: TextButton(
                            child: const Text('Export PNG'),
                            onPressed: () async {
                              final Uint8List? pngBytes = await getBytes();
                              if (pngBytes != null) saveFile(pngBytes, 'png');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: TextButton(
                            child: const Text('Export JPEG'),
                            onPressed: () async {
                              final Uint8List? pngBytes = await getBytes();
                              if (pngBytes != null) saveFile(pngBytes, 'jpeg');
                            },
                          ),
                        ),
                      ],
                    ),
                    // add about me button or follow buttons
                    const Divider(),
                    Center(
                      child: GestureDetector(
                        onTap: () => _launchUrl('https://github.com/JideGuru'),
                        child: const Text(
                          'Made with 💙 by JideGuru',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
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
        mimeType: extension == 'png' ? MimeType.png : MimeType.jpeg,
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    if (kIsWeb) {
      html.window.open(
        url,
        url,
      );
    } else {
      if (!await launchUrl(Uri.parse(url))) {
        throw 'Could not launch $url';
      }
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
          height: 35,
          width: 35,
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
                  size: 20,
                ),
          ),
        ),
      ),
    );
  }
}
