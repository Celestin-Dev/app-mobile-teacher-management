import '../../../core/network/api_client.dart';
import 'models/department_model.dart';

class DepartmentRepository {
  final ApiClient _client;
  DepartmentRepository(this._client);

  Future<List<DepartmentModel>> getAllDepartments() async {
    final res = await _client.dio.get('/departments');
    return (res.data as List).map((e) => DepartmentModel.fromJson(e)).toList();
  }
}
