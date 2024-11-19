import 'package:cloudease/core/constants/widgets.dart';
import 'package:cloudease/features/auth/data/auth_provider.dart';
import 'package:cloudease/features/home/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late final SupabaseClient _supabaseClient;
  late String userName;
  String? userProfileImage;

  @override
  void initState() {
    super.initState();
    _supabaseClient = Supabase.instance.client;
    userName = Provider.of<AuthProvider>(context, listen: false).userName;

    if (userName.isEmpty) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user != null) {
        final response = await _supabaseClient
            .from('users') // Replace with your table name
            .select('name') // Fetch both name and profile image
            .eq('email', user.email ?? '')
            .single();

        if (mounted) {
          Provider.of<AuthProvider>(context, listen: false).saveUserName(response['name']);
          setState(() {
            userName = response['name'];
            userProfileImage = response['profile_image'];
          });
        }
      }
    } catch (e) {
      AppWidgets.showSnackBar(context, 'Failed to fetch user data: $e');
    }
  }

  void navigateToLogin() {
    if (mounted) {
      context.go('/');
    }
  }

  void showSnackBar(String text) {
    AppWidgets.showSnackBar(context, text);
  }

  Future<void> logout() async {
    try {
      final apiService = AuthProvider();
      await apiService.signOutUser();
      if (Supabase.instance.client.auth.currentSession == null) {
        navigateToLogin();
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              // Profile Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userProfileImage != null
                          ? NetworkImage(userProfileImage!)
                          : null,
                      child: userProfileImage == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Logout Tile
              MyDrawerTile(
                title: 'Logout',
                icon: Icons.logout,
                onTap: logout,
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
