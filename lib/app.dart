import 'package:cloudease/features/auth/data/auth_provider.dart';
import 'package:cloudease/features/auth/screens/login.dart';
import 'package:cloudease/features/counter/providers/counter_provider.dart';
import 'package:cloudease/features/home/data/home_provider.dart';
import 'package:cloudease/features/home/screens/course/course_screen.dart';
import 'package:cloudease/features/home/screens/course/views/view_assignment.dart';
import 'package:cloudease/features/home/screens/course_comments.dart';
import 'package:cloudease/features/home/screens/home.dart';
import 'package:cloudease/models/assignment.dart';
import 'package:cloudease/models/comments.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CounterProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }


    final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      // Login screen route
       GoRoute(
        path: '/',
        builder: (context, state) {
          final user = Supabase.instance.client.auth.currentUser;
          if (user != null) {
            return const Home();
          } else {
            return const Login();
          }
        },
      ),
      // Home screen route
      GoRoute(
        path: '/home',
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: '/course-comment/:courseId',
        builder: (context, state) {
          // Access the stream from extra data
          final extra = state.extra as Map<String, dynamic>;
          final commentStream = extra['commentsStream'] as Stream<List<Comment>>;
          
          return CourseCommentsWidget(
            extra: extra,
            commentsStream: commentStream,
            onSubmitComment: (comment, file) {
              // Now we can use courseId in the submission
            },
          );
        },
      ),
      GoRoute(
        path: '/course/:courseId',
        builder: (context, state) => CourseScreen(extra: state.extra as Map<String, dynamic>)
      ),
      GoRoute(
          path: '/view_assignment',
          builder: (context, state) {
            final assignment = state.extra as Assignment; // Pass the assignment as extra
            return ViewAssignment(assignment: assignment);
          },
      ),
    ],
  );
}