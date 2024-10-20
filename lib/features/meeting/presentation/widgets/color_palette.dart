import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:sizer/sizer.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/whiteboard/whiteboard_bloc.dart';
import 'package:waterbus/gen/assets.gen.dart';

final List<Color> colors = [
  Colors.amber,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.brown,
  Colors.cyan,
  Colors.blueGrey,
  Colors.teal,
  Colors.indigo,
  Colors.black,
];

class ColorPalette extends StatelessWidget {
  final Color selectedColorListenable;

  const ColorPalette({
    super.key,
    required this.selectedColorListenable,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 25.sp,
              width: 25.sp,
              decoration: BoxDecoration(
                color: selectedColorListenable,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              height: 12.sp,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  showColorWheel(context, selectedColorListenable);
                },
                child: Assets.icons.colorPicker.image(
                  height: 25.sp,
                  width: 25.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 24.sp),
        Expanded(
          child: Wrap(
            spacing: 10,
            runSpacing: 7,
            runAlignment: WrapAlignment.center,
            children: [
              for (final Color color in colors)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => {
                      AppBloc.whiteBoardBloc.add(ChangeColorEvent(color)),
                    },
                    child: Container(
                      height: 25.sp,
                      width: 25.sp,
                      decoration: BoxDecoration(
                        color: color,
                        border: selectedColorListenable == color
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : null,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
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
