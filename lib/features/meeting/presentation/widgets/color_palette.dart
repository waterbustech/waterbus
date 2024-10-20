import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/whiteboard/whiteboard_bloc.dart';

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
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.brown,
      Colors.cyan,
    ];

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
                shape: BoxShape.circle,
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
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 2.w,
        ),
        SizedBox(
          height: 8.h,
          width: 20.w,
          child: Center(
            child: Wrap(
              spacing: 10,
              runSpacing: 7,
              children: [
                for (final Color color in colors)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => {
                        AppBloc.whiteBoardBloc.add(ChangeColorEvent(color)),
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(
                            color: selectedColorListenable == color
                                ? Colors.blue
                                : Colors.grey,
                            width: 1.5,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
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
              onPressed: () => {
                AppBloc.whiteBoardBloc.add(ChangeColorEvent(color)),
                Navigator.pop(context),
              },
            ),
          ],
        );
      },
    );
  }
}
