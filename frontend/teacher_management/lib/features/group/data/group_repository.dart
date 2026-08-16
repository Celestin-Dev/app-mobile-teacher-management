import '../../../core/network/api_client.dart';
import 'models/group_model.dart';

class GroupRepository {
  final ApiClient _client;
  GroupRepository(this._client);

  Future<List<GroupModel>> getAllGroups() async {
    final res = await _client.dio.get('/groups');
    return (res.data as List).map((e) => GroupModel.fromJson(e)).toList();
  }
}
