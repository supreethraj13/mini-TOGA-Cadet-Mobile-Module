import '../../../core/errors/app_error.dart';

class CadetProfile {
  CadetProfile({
    required this.id,
    required this.name,
    required this.role,
    required this.course,
    required this.base,
    required this.fto,
    required this.instructor,
  }) {
    if (role.toLowerCase() != 'cadet') {
      throw AppError(
        'Only cadet profiles can access this module.',
        code: 'role_scope',
      );
    }
  }

  final String id;
  final String name;
  final String role;
  final String course;
  final String base;
  final FtoInfo fto;
  final InstructorInfo instructor;

  factory CadetProfile.fromJson(Map<String, dynamic> json) => CadetProfile(
    id: json['id'] as String,
    name: json['name'] as String,
    role: json['role'] as String,
    course: json['course'] as String,
    base: json['base'] as String,
    fto: FtoInfo.fromJson(Map<String, dynamic>.from(json['fto'] as Map)),
    instructor: InstructorInfo.fromJson(
      Map<String, dynamic>.from(json['instructor'] as Map),
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'course': course,
    'base': base,
    'fto': fto.toJson(),
    'instructor': instructor.toJson(),
  };
}

class FtoInfo {
  const FtoInfo({required this.id, required this.name, required this.base});

  final String id;
  final String name;
  final String base;

  factory FtoInfo.fromJson(Map<String, dynamic> json) => FtoInfo(
    id: json['id'] as String,
    name: json['name'] as String,
    base: json['base'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'base': base};
}

class InstructorInfo {
  const InstructorInfo({
    required this.id,
    required this.name,
    required this.rating,
  });

  final String id;
  final String name;
  final String rating;

  factory InstructorInfo.fromJson(Map<String, dynamic> json) => InstructorInfo(
    id: json['id'] as String,
    name: json['name'] as String,
    rating: json['rating'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'rating': rating};
}
