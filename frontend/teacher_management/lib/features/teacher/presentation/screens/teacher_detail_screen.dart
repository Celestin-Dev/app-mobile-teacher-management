import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_management/features/subjects/presentation/widgets/edit_subject_sheet.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/default_avatar.dart';
import '../../../subjects/presentation/widgets/subject_row_card.dart';
import '../widgets/group_filter_chip.dart';
import '../providers/teacher_providers.dart';
import '../widgets/teacher_stats_card.dart';
import '../widgets/tab_selector.dart';
import '../../../../core/widgets/confirm_delete_dialog.dart';
import 'package:flutter/services.dart';
import '../../../subjects/presentation/providers/subject_providers.dart';

const _kSubjectFilters = ['Tous', 'GB', 'ASR', 'IG', 'OCC', 'GID'];

class TeacherDetailScreen extends ConsumerStatefulWidget {
  final int teacherId;
  const TeacherDetailScreen({super.key, required this.teacherId});

  @override
  ConsumerState<TeacherDetailScreen> createState() =>
      _TeacherDetailScreenState();
}

class _TeacherDetailScreenState extends ConsumerState<TeacherDetailScreen> {
  int _tabIndex = 0;
  String _selectedGroupFilter = 'Tous';

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.eniGreen,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teacherAsync = ref.watch(teacherDetailProvider(widget.teacherId));
    final subjectsAsync = ref.watch(teacherSubjectsProvider(widget.teacherId));

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: teacherAsync.when(
        data: (teacher) => subjectsAsync.when(
          data: (subjects) {
            final groupsCount = subjects.map((s) => s.groupName).toSet().length;
            final filtered = _selectedGroupFilter == 'Tous'
                ? subjects
                : subjects
                      .where(
                        (s) => (s.groupName ?? '').toUpperCase().contains(
                          _selectedGroupFilter.toUpperCase(),
                        ),
                      )
                      .toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _Header(
                        fullName: teacher.fullName,
                        grade: teacher.grade ?? 'Enseignant',
                        specialty: teacher.specialty,
                        email: teacher.email,
                        phone: teacher.phone,
                        matricule: teacher.matricule,
                        photoUrl: teacher.photo,
                      ),
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: -46,
                        child: TeacherStatsCard(
                          subjectsCount: subjects.length,
                          groupsCount: groupsCount,
                        ),
                      ),
                    ],
                  ),
                ),
                // Espace de respiration pour compenser le débordement de la carte
                const SliverToBoxAdapter(child: SizedBox(height: 60)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: TabSelector(
                      tabs: const ['Matières', 'Programme'],
                      selectedIndex: _tabIndex,
                      onChanged: (i) => setState(() => _tabIndex = i),
                    ),
                  ),
                ),
                if (_tabIndex == 0) ...[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 42,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: _kSubjectFilters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final label = _kSubjectFilters[i];
                          return GroupFilterChip(
                            label: label,
                            selected: _selectedGroupFilter == label,
                            onTap: () =>
                                setState(() => _selectedGroupFilter = label),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 18)),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    sliver: filtered.isEmpty
                        ? const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Center(
                                child: Text('Aucune matière dans ce parcours'),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => SubjectRowCard(
                                subject: filtered[i],
                                onEdit: () async {
                                  final updated = await EditSubjectSheet.show(
                                    context,
                                    filtered[i],
                                  );
                                  if (updated) {
                                    ref.invalidate(
                                      teacherSubjectsProvider(widget.teacherId),
                                    );
                                  }
                                },
                                onDelete: () async {
                                  final confirmed = await ConfirmDeleteDialog.show(
                                    context,
                                    title: 'Retirer cette matière ?',
                                    message:
                                        '« ${filtered[i].name} » sera retirée des matières attribuées à ${teacher.fullName}.',
                                  );

                                  if (confirmed) {
                                    try {
                                      await ref
                                          .read(subjectRepositoryProvider)
                                          .removeSubjectFromTeacher(
                                            teacherId: widget.teacherId,
                                            subjectId: filtered[i].id,
                                          );
                                      ref.invalidate(
                                        teacherSubjectsProvider(
                                          widget.teacherId,
                                        ),
                                      );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Matière retirée avec succès',
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('Erreur : $e'),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                              childCount: filtered.length,
                            ),
                          ),
                  ),
                ] else
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: Text('Programme — à venir')),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.eniGreen),
          ),
          error: (e, _) => Center(child: Text('Erreur : $e')),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.eniGreen),
        ),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String fullName;
  final String grade;
  final String? specialty;
  final String? email;
  final String? phone;
  final String matricule;
  final String? photoUrl;

  const _Header({
    required this.fullName,
    required this.grade,
    required this.matricule,
    this.specialty,
    this.email,
    this.phone,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 60),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.eniGreen, AppColors.eniGreenDark],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Cercles décoratifs
            Positioned(
              top: 60,
              right: -10,
              child: _decoCircle(90, Colors.white.withOpacity(0.10)),
            ),
            Positioned(
              top: 130,
              right: 150,
              child: _decoCircle(46, Colors.white.withOpacity(0.14)),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _roundIconButton(
                      Icons.chevron_left,
                      () => Navigator.of(context).maybePop(),
                    ),
                    _roundIconButton(Icons.edit_outlined, () {
                      // TODO: navigation édition enseignant
                    }),
                  ],
                ),
                const SizedBox(height: 18),
                DefaultAvatar(size: 92, photoUrl: photoUrl),
                const SizedBox(height: 18),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  specialty != null ? '$grade · $specialty' : grade,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: [
                    if (email != null) _contactRow(Icons.mail_outline, email!),
                    if (phone != null) _contactRow(Icons.call_outlined, phone!),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'ID: $matricule',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white.withOpacity(0.85)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.5,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _decoCircle(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
