class DepartmentModel {
  final int id;
  final String name;

  DepartmentModel({required this.id, required this.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      DepartmentModel(id: json['id'], name: json['name']);
}
