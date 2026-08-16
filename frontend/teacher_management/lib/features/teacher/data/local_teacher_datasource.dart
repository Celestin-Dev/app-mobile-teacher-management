import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'models/teacher_model.dart';

class LocalTeacherDatasource {
  static const _assetPath = 'assets/data/teachers.json';

  Future<List<TeacherModel>> loadTeachers() async {
    final raw = await rootBundle.loadString(_assetPath);
    final List<dynamic> jsonList = jsonDecode(raw);
    return jsonList.map((e) => TeacherModel.fromJson(e)).toList();
  }
}
