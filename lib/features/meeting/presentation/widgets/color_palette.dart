import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/options/drawing_options_bloc.dart';

class ColorPalette extends StatelessWidget {
  final Color selectedColorListenable;

  const ColorPalette({
    super.key,
    required this.selectedColorListenable,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.black,
      Colors.white,
      ...Colors.primaries,
    ];
    final scrollController = ScrollController();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: selectedColorListenable,
                border: Border.all(color: Colors.blue, width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  showColorWheel(context, selectedColorListenable);
                },
                child: SvgPicture.asset(
                  'assets/svgs/color_wheel.svg',
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 2.w,
        ),
        SizedBox(
          height: 10.h,
          width: 12.w,
          child: Scrollbar(
            controller: scrollController,
            scrollbarOrientation: ScrollbarOrientation.right,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 4,
                runSpacing: 5,
                children: [
                  for (final Color color in colors)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => {
                          AppBloc.drawingOptionsBloc
                              .add(ChangeColorEvent(color)),
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: color,
                            border: Border.all(
                              color: selectedColorListenable == color
                                  ? Colors.blue
                                  : Colors.grey,
                              width: 1.5,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void showColorWheel(BuildContext context, Color color) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: color,
              onColorChanged: (value) {
                color = value;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
