import 'package:cloudease/features/home/screens/course/section/assignment_screen.dart';
import 'package:cloudease/features/home/screens/course/section/modules_screen.dart';
import 'package:cloudease/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseScreen extends StatefulWidget {
  final Map<String, dynamic> extra;
  const CourseScreen({super.key, required this.extra});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: lightBlue,
          iconTheme: IconThemeData(color: white),
          title: Text(widget.extra['courseTitle']),
          titleTextStyle: TextStyle(color: white, fontSize: 17),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: white),
              onPressed: () => context.go('/home'),
            ),
          bottom: TabBar(
            labelColor: white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: white,
            unselectedLabelColor: Colors.grey.shade800,
            tabs: const [
              Tab(icon: Icon(Icons.subject), text: 'Modules'),
              Tab(icon: Icon(Icons.assignment), text: 'Assignments',)
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ModulesScreen(),
            AssignmentScreen(courseId: widget.extra['courseId'])
          ],
        ),
      ),
    );
  }
}