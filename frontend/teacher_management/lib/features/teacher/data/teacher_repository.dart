// features/teacher/data/teacher_repository.dart
import '../../../core/network/api_client.dart';
import '../../subjects/data/models/subject_model.dart';
import 'models/teacher_model.dart';

class TeacherRepository {
  final ApiClient _client;
  TeacherRepository(this._client);

  Future<List<TeacherModel>> getAllTeachers({String? group}) async {
    final res = await _client.dio.get(
      '/teachers',
      queryParameters: (group != null && group != 'Tous')
          ? {'group': group}
          : null,
    );
    return (res.data as List).map((e) => TeacherModel.fromJson(e)).toList();
  }

  Future<TeacherModel> getTeacherById(int id) async {
    final res = await _client.dio.get('/teachers/$id');
    return TeacherModel.fromJson(res.data);
  }

  Future<List<SubjectModel>> getSubjectsByTeacher(int teacherId) async {
    final res = await _client.dio.get('/teachers/$teacherId/subjects');
    return (res.data as List).map((e) => SubjectModel.fromJson(e)).toList();
  }

  Future<List<TeacherModel>> searchTeachers(String name) async {
    final res = await _client.dio.get(
      '/teachers/search',
      queryParameters: {'name': name},
    );
    return (res.data as List).map((e) => TeacherModel.fromJson(e)).toList();
  }

  Future<TeacherModel> createTeacher({
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    required int departmentId,
    String? specialty,
  }) async {
    final res = await _client.dio.post(
      '/teachers',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'departmentId': departmentId,
        'specialty': specialty,
      },
    );
    return TeacherModel.fromJson(res.data);
  }
}
