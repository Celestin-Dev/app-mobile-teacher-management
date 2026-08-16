import '../../../core/network/api_client.dart';
import 'models/subject_model.dart';

class SubjectRepository {
  final ApiClient _client;
  SubjectRepository(this._client);

  Future<SubjectModel> updateSubject({
    required int subjectId,
    required String name,
    required double credits,
    int? groupId,
  }) async {
    final res = await _client.dio.put(
      '/subjects/$subjectId',
      data: {
        'name': name,
        'credits': credits,
        if (groupId != null) 'groupId': groupId,
      },
    );
    return SubjectModel.fromJson(res.data);
  }

  Future<void> removeSubjectFromTeacher({
    required int teacherId,
    required int subjectId,
  }) async {
    await _client.dio.delete('/teachers/$teacherId/subjects/$subjectId');
  }
}
