import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
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

            final Uint8List resizedImage = await ImageUtils().reduceSize(
              File(image.path).path,
            );

            handleFinish(resizedImage);

            AppNavigator.pop();
          }
        } catch (exception) {
          debugPrint(exception.toString());
        }
      },
      style: ButtonStyle(
        animationDuration: Duration.zero,
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.black.withOpacity(0.5);
            }
            return Colors.black;
          },
        ),
        overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
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
    Function(Uint8List)? handleFinish,
  }) async {
    if (WebRTC.platformIsDesktop || WebRTC.platformIsWeb) {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result?.files.isNotEmpty ?? false) {
        final Uint8List? resizedImage = WebRTC.platformIsMacOS
            ? await ImageUtils().reduceSize(
                File(result!.files.first.path!).path,
              )
            : kIsWeb
                ? result?.files.first.bytes
                : File(result!.files.first.path!).readAsBytesSync();

        if (resizedImage == null) return;

        handleFinish?.call(resizedImage);
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
              Strings.changeYourAvatar.i18n,
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
              icon: PhosphorIcons.folderOpen(),
              text: Strings.chooseFromGallery.i18n,
              source: ImageSource.gallery,
              handleFinish: handleFinish,
            ),
            divider,
            _buildImageModalButton(
              context,
              icon: PhosphorIcons.camera(),
              text: Strings.takeAPhoto.i18n,
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
