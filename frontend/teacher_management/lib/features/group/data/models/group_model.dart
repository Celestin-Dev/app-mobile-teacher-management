class GroupModel {
  final int id;
  final String code;
  final String name;
  final String level;

  GroupModel({
    required this.id,
    required this.code,
    required this.name,
    required this.level,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json['id'],
    code: json['code'],
    name: json['name'],
    level: json['level'],
  );

  /// Ex: "GB · L3"
  String get shortLabel => '$code · $level';
}
