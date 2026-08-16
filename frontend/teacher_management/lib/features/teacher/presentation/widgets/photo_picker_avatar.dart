import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/default_avatar.dart';

class PhotoPickerAvatar extends StatelessWidget {
  final File? localFile;
  final String? photoUrl;
  final VoidCallback onTap;

  const PhotoPickerAvatar({
    super.key,
    this.localFile,
    this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.line, width: 1.4),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (localFile != null)
                  ClipOval(
                    child: Image.file(
                      localFile!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  DefaultAvatar(size: 100, photoUrl: photoUrl),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.line, width: 1.2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 16,
                      color: AppColors.eniGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Text(
            localFile != null ? 'Changer la photo' : 'Importer photo',
            style: const TextStyle(
              color: AppColors.eniGreen,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
