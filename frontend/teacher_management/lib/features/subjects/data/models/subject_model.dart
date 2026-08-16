// features/subjects/data/models/subject_model.dart
class SubjectModel {
  final int id;
  final String code;
  final String name;
  final double credits;
  final int? groupId;
  final String? groupName;

  SubjectModel({
    required this.id,
    required this.code,
    required this.name,
    required this.credits,
    this.groupId,
    this.groupName,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
    id: json['id'],
    code: json['code'],
    name: json['name'],
    credits: (json['credits'] as num).toDouble(),
    groupId: (json['groupId'] ?? json['group_id']) as int?,
    groupName: json['groupName'] as String?,
  );
}
