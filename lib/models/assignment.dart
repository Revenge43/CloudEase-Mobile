class Assignment {
  final String id; 
  final String courseId; 
  final String assignmentTitle; 
  final String assignmentDescription; 
  final String assignmentFile; 
  final DateTime? createdAt; 
  final DateTime? updatedAt; 
  final String assignmentScore;

  Assignment({
    required this.id,
    required this.courseId,
    required this.assignmentTitle,
    required this.assignmentDescription,
    required this.assignmentFile,
    required this.createdAt,
    required this.updatedAt,
    required this.assignmentScore,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] ?? '',
      courseId: json['course_id'] ?? '',
      assignmentTitle: json['assignment_title'] ?? '',
      assignmentDescription: json['assignment_description'] ?? '',
      assignmentFile: json['assignment_file'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      assignmentScore: json['assignment_score'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'assignment_title': assignmentTitle,
      'assignment_description': assignmentDescription,
      'assignment_file': assignmentFile,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'assignment_score': assignmentScore,
    };
  }
}