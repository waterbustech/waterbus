import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/domain/models/drawing_tool.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/options/drawing_options_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/color_palette.dart';

class CanvasSideBar extends StatefulWidget {
  final GlobalKey canvasGlobalKey;

  const CanvasSideBar({
    Key? key,
    required this.canvasGlobalKey,
  }) : super(key: key);

  @override
  State<CanvasSideBar> createState() => _CanvasSideBarState();
}

class _CanvasSideBarState extends State<CanvasSideBar> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingOptionsBloc, DrawingOptionsState>(
      builder: (context, state) {
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
                  alignment: WrapAlignment.start,
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    _IconBox(
                      iconData: FontAwesomeIcons.pencil,
                      selected: state.drawingTool == DrawingTool.pencil,
                      onTap: () => AppBloc.drawingOptionsBloc.add(
                        const ChangeDrawingToolEvent(DrawingTool.pencil),
                      ),
                      tooltip: 'Pencil',
                    ),
                    _IconBox(
                      selected: state.drawingTool == DrawingTool.line,
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
                            color: state.drawingTool == DrawingTool.line
                                ? Colors.grey[900]
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    _IconBox(
                      iconData: Icons.hexagon_outlined,
                      selected: state.drawingTool == DrawingTool.polygon,
                      onTap: () => AppBloc.drawingOptionsBloc.add(
                          const ChangeDrawingToolEvent(DrawingTool.polygon)),
                      tooltip: 'Polygon',
                    ),
                    _IconBox(
                      iconData: FontAwesomeIcons.eraser,
                      selected: state.drawingTool == DrawingTool.eraser,
                      onTap: () => AppBloc.drawingOptionsBloc.add(
                          const ChangeDrawingToolEvent(DrawingTool.eraser)),
                      tooltip: 'Eraser',
                    ),
                    _IconBox(
                      iconData: FontAwesomeIcons.square,
                      selected: state.drawingTool == DrawingTool.square,
                      onTap: () => AppBloc.drawingOptionsBloc.add(
                          const ChangeDrawingToolEvent(DrawingTool.square)),
                      tooltip: 'Square',
                    ),
                    _IconBox(
                      iconData: FontAwesomeIcons.circle,
                      selected: state.drawingTool == DrawingTool.circle,
                      onTap: () => AppBloc.drawingOptionsBloc.add(
                          const ChangeDrawingToolEvent(DrawingTool.circle)),
                      tooltip: 'Circle',
                    ),
                    _IconBox(
                      iconData: FontAwesomeIcons.ruler,
                      selected: state.showGrid,
                      onTap: () => AppBloc.drawingOptionsBloc
                          .add(ToggleGridEvent(!state.showGrid)),
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
                      value: state.filled,
                      onChanged: (val) {
                        AppBloc.drawingOptionsBloc
                            .add(ToggleFilledEvent(val ?? false));
                      },
                    ),
                  ],
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: state.drawingTool == DrawingTool.polygon
                      ? Row(
                          children: [
                            const Text(
                              'Polygon Sides: ',
                              style: TextStyle(fontSize: 12),
                            ),
                            Slider(
                              value: state.polygonSides.toDouble(),
                              min: 3,
                              max: 8,
                              onChanged: (val) {
                                AppBloc.drawingOptionsBloc
                                    .add(ChangePolygonSidesEvent(val.toInt()));
                              },
                              label: '${state.polygonSides}',
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
                  selectedColorListenable: state.selectedColor,
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
                      value: state.strokeSize,
                      min: 0,
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
                      value: state.eraserSize,
                      min: 0,
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
                // Wrap(
                //   children: [
                //     TextButton(
                //       onPressed: state.allSketches.isNotEmpty
                //           ? () => undoRedoStack.undo()
                //           : null,
                //       child: const Text('Undo'),
                //     ),
                //     ValueListenableBuilder<bool>(
                //       valueListenable: undoRedoStack.canRedo,
                //       builder: (_, canRedo, __) {
                //         return TextButton(
                //           onPressed:
                //               canRedo ? () => undoRedoStack.redo() : null,
                //           child: const Text('Redo'),
                //         );
                //       },
                //     ),
                //     TextButton(
                //       child: const Text('Clear'),
                //       onPressed: () => undoRedoStack.clear(),
                //     ),
                //     TextButton(
                //       onPressed: () async {
                //         if (state.backgroundImage != null) {
                //           state.backgroundImage = null;
                //         } else {
                //           state.backgroundImage = await _getImage;
                //         }
                //       },
                //       child: Text(
                //         state.backgroundImage == null
                //             ? 'Add Background'
                //             : 'Remove Background',
                //       ),
                //     ),
                //     TextButton(
                //       child: const Text('Fork on Github'),
                //       onPressed: () => _launchUrl(kGithubRepo),
                //     ),
                //   ],
                // ),
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
  }

  void saveFile(Uint8List bytes, String extension) async {
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

  Future<ui.Image> get _getImage async {
    final completer = Completer<ui.Image>();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
      final file = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (file != null) {
        final filePath = file.files.single.path;
        final bytes = filePath == null
            ? file.files.first.bytes
            : File(filePath).readAsBytesSync();
        if (bytes != null) {
          completer.complete(decodeImageFromList(bytes));
        } else {
          completer.completeError('No image selected');
        }
      }
    } else {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        completer.complete(
          decodeImageFromList(bytes),
        );
      } else {
        completer.completeError('No image selected');
      }
    }

    return completer.future;
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
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
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
    Key? key,
    this.iconData,
    this.child,
    this.tooltip,
    required this.selected,
    required this.onTap,
  })  : assert(child != null || iconData != null),
        super(key: key);

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
