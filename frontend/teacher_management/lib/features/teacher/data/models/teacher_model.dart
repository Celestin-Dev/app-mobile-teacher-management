class TeacherModel {
  final int id;
  final String matricule;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? grade;
  final String? specialty;
  final String? photo;

  TeacherModel({
    required this.id,
    required this.matricule,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.grade,
    this.specialty,
    this.photo,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) => TeacherModel(
    id: json['id'],
    matricule: json['matricule'],
    // Supporte les deux formats : camelCase (API) et snake_case (JSON local)
    firstName: json['firstName'] ?? json['first_name'] ?? '-',
    lastName: json['lastName'] ?? json['last_name'] ?? '-',
    email: json['email'],
    phone: json['phone'],
    grade: json['grade'],
    specialty: json['specialty'],
    photo: json['photo'],
  );

  String get fullName => '$lastName $firstName';
}
