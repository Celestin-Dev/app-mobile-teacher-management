import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../subjects/data/models/subject_model.dart';
import '../../data/local_teacher_datasource.dart';
import '../../data/teacher_repository.dart';
import '../../data/models/teacher_model.dart';

/// Passez à `false` quand le backend est prêt et branché
const bool kUseLocalTeacherData = true;

// ---------- Sources de données ----------
final localTeacherDatasourceProvider = Provider(
  (ref) => LocalTeacherDatasource(),
);

final apiClientProvider = Provider((ref) => ApiClient());

final teacherRepositoryProvider = Provider(
  (ref) => TeacherRepository(ref.watch(apiClientProvider)),
);

// ---------- Liste ----------
final selectedGroupProvider = StateProvider<String>((ref) => 'Tous');

final teacherListProvider = FutureProvider<List<TeacherModel>>((ref) async {
  final group = ref.watch(selectedGroupProvider);

  if (kUseLocalTeacherData) {
    final all = await ref.watch(localTeacherDatasourceProvider).loadTeachers();
    if (group == 'Tous') return all;
    return all
        .where(
          (t) =>
              (t.specialty ?? '').toUpperCase().contains(group.toUpperCase()),
        )
        .toList();
  }

  return ref
      .watch(teacherRepositoryProvider)
      .getAllTeachers(group: group == 'Tous' ? null : group);
});

// ---------- Recherche ----------
final searchQueryProvider = StateProvider<String>((ref) => '');

final teacherSearchProvider = FutureProvider<List<TeacherModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  if (kUseLocalTeacherData) {
    final all = await ref.watch(localTeacherDatasourceProvider).loadTeachers();
    return all
        .where((t) => t.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  return ref.watch(teacherRepositoryProvider).searchTeachers(query);
});

// ---------- Détail ----------
final teacherDetailProvider = FutureProvider.family<TeacherModel, int>((
  ref,
  id,
) async {
  if (kUseLocalTeacherData) {
    final all = await ref.watch(localTeacherDatasourceProvider).loadTeachers();
    return all.firstWhere(
      (t) => t.id == id,
      orElse: () =>
          throw Exception('Enseignant $id introuvable (données locales)'),
    );
  }
  return ref.watch(teacherRepositoryProvider).getTeacherById(id);
});

// ---------- Matières d'un enseignant ----------
final teacherSubjectsProvider = FutureProvider.family<List<SubjectModel>, int>((
  ref,
  id,
) async {
  if (kUseLocalTeacherData) {
    final linksRaw = await rootBundle.loadString(
      'assets/data/teacher_subjects.json',
    );
    final subjectsRaw = await rootBundle.loadString(
      'assets/data/subjects.json',
    );
    final links = (jsonDecode(linksRaw) as List).where(
      (l) => l['teacher_id'] == id,
    );
    final allSubjects = (jsonDecode(subjectsRaw) as List)
        .map((e) => SubjectModel.fromJson(e))
        .toList();
    final ids = links.map((l) => l['subject_id']).toSet();
    return allSubjects.where((s) => ids.contains(s.id)).toList();
  }

  return ref.watch(teacherRepositoryProvider).getSubjectsByTeacher(id);
});
