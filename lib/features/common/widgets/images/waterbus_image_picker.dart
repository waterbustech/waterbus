// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/core/helpers/image_utils.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';

class WaterbusImagePicker {
  final ImagePicker _picker = ImagePicker();

  Widget _buildImageModalButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required ImageSource source,
    Function(Uint8List)? handleFinish,
  }) {
    return TextButton(
      onPressed: () async {
        try {
          AppNavigator.pop();
          final XFile? image = await _getImage(
            context: AppNavigator.context,
            source: source,
          );

          if (handleFinish != null && image != null) {
            displayLoadingLayer();

            final File resizedImage = await ImageUtils().reduceSize(
              File(image.path).path,
            );

            handleFinish(resizedImage.readAsBytesSync());

            AppNavigator.pop();
          }
        } catch (exception) {
          debugPrint(exception.toString());
        }
      },
      style: ButtonStyle(
        animationDuration: Duration.zero,
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black.withOpacity(0.5);
            }
            return Colors.black;
          },
        ),
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.sp),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
            SizedBox(width: 12.sp),
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 13.25.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openImagePicker({
    required BuildContext context,
    String text = 'Change your avatar',
    Function(Uint8List)? handleFinish,
  }) async {
    if (WebRTC.platformIsDesktop || WebRTC.platformIsWeb) {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (kIsWeb) {
        if (result?.files.first.bytes != null) {
          handleFinish?.call(result!.files.first.bytes!);
        }
      } else {
        if (result?.files.first.path != null) {
          final File imageFile = File(result!.files.first.path!);
          handleFinish?.call(imageFile.readAsBytesSync());
        }
      }

      return;
    }

    return showDialogWaterbus(
      alignment: Alignment.bottomCenter,
      paddingBottom: 56.sp,
      child: Container(
        width: double.infinity,
        height: 170.sp,
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.sp),
            Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(
              height: 6.sp,
            ),
            _buildImageModalButton(
              context,
              icon: PhosphorIcons.file_image,
              text: 'Choose photo from gallery',
              source: ImageSource.gallery,
              handleFinish: handleFinish,
            ),
            divider,
            _buildImageModalButton(
              context,
              icon: PhosphorIcons.instagram_logo,
              text: 'Take a photo',
              source: ImageSource.camera,
              handleFinish: handleFinish,
            ),
            SizedBox(
              height: 8.sp,
            ),
          ],
        ),
      ),
    );
  }

  // MARK: private
  Future _getImage({context, source = ImageSource.gallery}) async {
    return await _picker.pickImage(source: source, imageQuality: 100);
  }
}
