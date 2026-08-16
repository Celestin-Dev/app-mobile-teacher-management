import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../teacher/presentation/providers/teacher_providers.dart';
import '../../data/subject_repository.dart';

final subjectRepositoryProvider = Provider(
  (ref) => SubjectRepository(ref.watch(apiClientProvider)),
);
