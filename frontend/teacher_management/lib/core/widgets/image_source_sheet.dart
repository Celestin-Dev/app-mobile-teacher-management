import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';

class ImageSourceSheet {
  static Future<XFile?> show(BuildContext context) async {
    final picker = ImagePicker();

    return showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.eniGreen,
              ),
              title: const Text('Choisir depuis la galerie'),
              onTap: () async {
                final file = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (ctx.mounted) Navigator.of(ctx).pop(file);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.eniGreen,
              ),
              title: const Text('Prendre une photo'),
              onTap: () async {
                final file = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (ctx.mounted) Navigator.of(ctx).pop(file);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
