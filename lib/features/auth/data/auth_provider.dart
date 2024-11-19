import 'package:cloudease/models/users.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  String _role = '';
  final String _email = '';
  final String _userId = '';
  String _userName = '';

  late Session _sessionToken;

  String get role => _role;
  String get email => _email;
  String get userId => _userId;
  String get userName => _userName;
  Session get sessionToken => _sessionToken;
  void saveRole(String newRole) {
    _role = newRole;
    notifyListeners();
  }

  void saveUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  Future<AppUser?> signUpUser(String email, String password, String name, String role) async {
    final supabase = Supabase.instance.client;

    try {
      // Sign up user with authentication (Supabase handles password hashing)
        AuthResponse authResponse = await supabase.auth.signUp(email: email, password: password);

        // Insert additional user details to 'users' table
        final response = await supabase.from('users').insert({
          'name': name,
          'email': authResponse.user!.email,
          'role': role.toLowerCase()
        }).select();

        final userData = response.first;

        var mapUser = AppUser.fromJson(userData);

        _userName = mapUser.name;
        notifyListeners();

        return mapUser;
      
    } catch (e) {
      throw Exception(e is AuthException ? e.message : e);
    }
  }


  Future<AppUser?> loginUser(String email, String password) async {
    final supabase = Supabase.instance.client;

    try {
      // Sign in user with email and password
      AuthResponse authResponse = await supabase.auth.signInWithPassword(email: email, password: password);

      // Check if the response contains a user object

      final response = await supabase.from('users').select('role').eq('email', authResponse.user?.email.toString() ?? '').select();

      final userData = response.first;

      return AppUser.fromJson(userData);
    } catch (e) {
      throw Exception(e is AuthException ? e.message : e);
    }
  }

  Future<void> signOutUser() async {
    try {
        await Supabase.instance.client.auth.signOut();
    } catch (e) {
      throw Exception(e is AuthException ? e.message : e);
    }
  }

}
