import 'dart:async';

import 'package:cloudease/features/home/data/home_provider.dart';
import 'package:cloudease/features/home/widgets/module.dart';
import 'package:cloudease/models/courses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {

  final homeProvider = HomeProvider();
  late final StreamSubscription<List<Course>> _subscription;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    // Initialize the stream subscription
    _subscription = homeProvider.getCoursesStream().listen(
      (courses) {
        if (_isFirstLoad) {
          _isFirstLoad = false;  // Set to false after first load
        }
        setState(() {});
      },
      onError: (error) {
        // Log the error for debugging
        print('Stream error: $error');
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel(); // Clean up subscription
    super.dispose();
  }

  Future<List<Course>> fetchData() async {
    try {
      await homeProvider.getCourses();
      return homeProvider.courses;

    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
      return StreamBuilder<List<Course>>(
        stream: homeProvider.getCoursesStream(), // Use stream instead of future
        builder: (context, snapshot) {
          
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting && _isFirstLoad) {
            return const Center(child: CupertinoActivityIndicator());
          }
          
          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            ); 
          }
          
          // Handle empty or null data
          final items = snapshot.data ?? [];
          if (items.isEmpty && snapshot.connectionState == ConnectionState.done) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_off, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No courses available'),
                ],
              ),
            );
          }

          // If data is available, display the grid
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // This creates a 2-column grid
                  crossAxisSpacing: 16.0, // Space between columns
                  mainAxisSpacing: 16.0, // Space between rows
                  childAspectRatio: 1.2, // Aspect ratio of the card
                ),
                itemCount: items.length, // Dynamically set based on data
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ModuleCard(
                    title: item.title,
                    icon: Icons.image, // Use different icon
                    image: item.image != '' ? Image.network(item.image!) : Image.asset('assets/images/no_image.jpg'), // No image for other cards
                    onTap: () {
                      context.go('/course/${item.courseId}', extra: {
                          // 'commentsStream': homeProvider.getCommentStream(),
                          'courseId': item.courseId,
                          'courseTitle': item.title
                      });


                      // context.go('/course-comment/${item.courseId}', extra: {
                      //     'commentsStream': homeProvider.getCommentStream(),
                      //     'courseId': item.courseId,
                      //     'courseTitle': item.title
                      // });
                    },
                  );
                },
              ),
          );
        }
    );
  }
}