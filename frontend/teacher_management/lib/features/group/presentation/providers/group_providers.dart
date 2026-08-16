import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../teacher/presentation/providers/teacher_providers.dart';
import '../../data/group_repository.dart';
import '../../data/models/group_model.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(ref.watch(apiClientProvider)),
);

final groupListProvider = FutureProvider<List<GroupModel>>((ref) {
  return ref.watch(groupRepositoryProvider).getAllGroups();
});
