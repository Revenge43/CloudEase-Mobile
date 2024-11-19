// lib/models/module.dart

class ModuleCategories {
  final int id;
  final String title;

  ModuleCategories({required this.id, required this.title});

  // Factory method to create a ModuleCategories instance from a map
  factory ModuleCategories.fromMap(Map<String, dynamic> json) {
    return ModuleCategories(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
    );
  }

  // Method to convert ModuleCategories instance to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class Modules {
  final int id;
  final int categoryId;
  final int courseId;
  final String title;
  final String description;
  final String file;
  final DateTime createdAt;
  final DateTime updatedAt;

  Modules({
    required this.id,
    required this.categoryId,
    required this.courseId,
    required this.title,
    required this.description,
    required this.file,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Modules instance from a map
  factory Modules.fromMap(Map<String, dynamic> json) {
    return Modules(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      courseId: json['course_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      file: json['file'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert Modules instance to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'course_id': courseId,
      'title': title,
      'description': description,
      'file': file,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}