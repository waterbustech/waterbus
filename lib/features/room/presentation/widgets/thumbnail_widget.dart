import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/colors/app_color.dart';

class ThumbnailWidget extends StatelessWidget {
  const ThumbnailWidget({
    super.key,
    required this.source,
    required this.selected,
    required this.onTap,
  });
  final DesktopCapturerSource source;
  final bool selected;
  final Function(DesktopCapturerSource) onTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Uint8List>(
      stream: source.onThumbnailChanged.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        return Column(
          children: [
            Expanded(
              child: Material(
                clipBehavior: Clip.hardEdge,
                shape: SuperellipseShape(
                  borderRadius: BorderRadius.circular(10.sp),
                  side: selected
                      ? BorderSide(
                          width: 2,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : BorderSide.none,
                ),
                child: InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      print('Selected source id => ${source.id}');
                    }
                    onTap(source);
                  },
                  child: Image.memory(
                    snapshot.data!,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
            Text(
              source.name,
              style: TextStyle(
                fontSize: 12,
                color: mC,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      },
    );
  }
}
