import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TeacherStatsCard extends StatelessWidget {
  final int subjectsCount;
  final int groupsCount;

  const TeacherStatsCard({
    super.key,
    required this.subjectsCount,
    required this.groupsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ← occupe toute la largeur parent
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max, // ← Row prend toute la largeur
          children: [
            Expanded(
              child: _StatItem(value: subjectsCount, label: 'Matières'),
            ),
            const VerticalDivider(color: AppColors.line, thickness: 1.4),
            Expanded(
              child: _StatItem(value: groupsCount, label: 'Parcours'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center, // ← centre horizontalement
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: AppColors.inkSoft),
        ),
      ],
    );
  }
}
