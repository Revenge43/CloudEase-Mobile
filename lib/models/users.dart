class AppUser {
  final int id;
  final String name;
  final String email;
  final String role;

  // Constructor
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // Factory constructor to create a AppUser from JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['user_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  // Method to convert a AppUser object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
