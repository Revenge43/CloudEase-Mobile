// lib/features/home/screens/course/assignment_screen.dart
import 'package:cloudease/features/home/data/home_provider.dart';
import 'package:cloudease/models/assignment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AssignmentScreen extends StatefulWidget {
  final String courseId; 
  const AssignmentScreen({super.key, required this.courseId});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

// lib/features/home/screens/course/assignment_screen.dart
class _AssignmentScreenState extends State<AssignmentScreen> {
  final homeProvider = HomeProvider();
  List<Assignment> assignments = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchAssignments();
  }

  Future<void> _fetchAssignments() async {
    await homeProvider.getAssignments(widget.courseId);
    setState(() {
      assignments = homeProvider.assignments; // Update state after fetching
      isLoading = false; // Set loading to false after fetching
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: isLoading // Check loading state
          ? const Center(child: CupertinoActivityIndicator()) // Show loading indicator
          : assignments.isEmpty ? const Center(child: Text('No Assignments Available')) 
          : ListView.builder(
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(assignment.assignmentTitle, style: const TextStyle(fontSize: 14)),
                      subtitle: Text(DateFormat('MMMM dd, yyyy').format(assignment.createdAt!)),
                      trailing: Text(assignment.assignmentScore),
                      visualDensity: VisualDensity.compact,
                      onTap: () => context.push('/view_assignment', extra: assignment),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
