import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../teacher/presentation/providers/teacher_providers.dart';
import '../../data/department_repository.dart';
import '../../data/models/department_model.dart';

final departmentRepositoryProvider = Provider(
  (ref) => DepartmentRepository(ref.watch(apiClientProvider)),
);

final departmentListProvider = FutureProvider<List<DepartmentModel>>((ref) {
  return ref.watch(departmentRepositoryProvider).getAllDepartments();
});
