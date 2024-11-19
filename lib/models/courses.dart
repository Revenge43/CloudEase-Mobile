class Course {
  final String courseId;
  final String title;
  final String description;
  final int score;
  final String? image;
  final DateTime createdAt;
  final String teacherId;

  // Constructor
  Course({
    required this.courseId,
    required this.title,
    required this.description,
    required this.score,
    this.image,
    required this.createdAt,
    required this.teacherId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      score: json['score'] ?? 0,
      image: json['image'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      teacherId: json['teacher_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'title': title,
      'description': description,
      'score': score,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'teacher_id': teacherId,
    };
  }

  // Static method to create a new Course with generated UUID and current timestamp
  // static Course create({
  //   required String title,
  //   required String description,
  //   required int score,
  //   String? attachment,
  //   required int teacherId,
  // }) {
  //   return Course(
  //     courseId: Uuid().v4(),
  //     title: title,
  //     description: description,
  //     score: score,
  //     attachment: attachment,
  //     createdAt: DateTime.now(),
  //     teacherId: teacherId,
  //   );
  // }
}
