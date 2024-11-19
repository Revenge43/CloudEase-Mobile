
enum MediaType { image, video }

class Comment {
  final int id;
  final String text;
  final int? teacherId;
  final int? userId;
  final String? courseId; // UUID for course_id
  final DateTime timestamp;
  final String? mediaUrl;
  final MediaType? mediaType;
  final String? thumbnailUrl; // For video thumbnails

  Comment({
    required this.id,
    required this.text,
    this.teacherId,
    this.userId,
    this.courseId,
    required this.timestamp,
    this.mediaUrl,
    this.mediaType,
    this.thumbnailUrl,
  });

  // Factory constructor to create a Comment object from JSON (e.g., API response)
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      text: json['text'] as String,
      teacherId: json['teacher_id'] as int?,
      userId: json['user_id'] as int?,
      courseId: json['course_id'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // Method to convert a Comment object to JSON (e.g., for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'teacher_id': teacherId,
      'user_id': userId,
      'course_id': courseId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
