// features/teachers/presentation/widgets/teacher_card.dart
import 'package:flutter/material.dart';
import 'package:teacher_management/core/widgets/default_avatar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/teacher_model.dart';

class TeacherCard extends StatelessWidget {
  final TeacherModel teacher;
  final String subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const TeacherCard({
    super.key,
    required this.teacher,
    required this.subtitle,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          children: [
            DefaultAvatar(photoUrl: teacher.photo, size: 50),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onMoreTap,
              icon: const Icon(Icons.more_horiz, color: AppColors.iconGrey),
            ),
          ],
        ),
      ),
    );
  }
}
