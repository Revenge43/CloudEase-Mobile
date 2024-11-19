import 'package:cloudease/features/home/widgets/module.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
@override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // This creates a 2-column grid
            crossAxisSpacing: 16.0, // Space between columns
            mainAxisSpacing: 16.0, // Space between rows
            childAspectRatio: 1.2, // Aspect ratio of the card
          ),
          itemCount: 6, // Total number of modules
          itemBuilder: (context, index) {
            return ModuleCard(
              title: getTitle(index),
              icon: getIcon(index),
              onTap: () {
                // Navigate to different screens based on the module
                // You can replace this with actual navigation logic
                print('Tapped on ${getTitle(index)}');
              },
            );
          },
        ),
      );
  }

  // Function to get module titles based on the index
  String getTitle(int index) {
    switch (index) {
      case 0:
        return "Courses";
      case 1:
        return "Posts";
      case 2:
        return "Students";
      case 3:
        return "Settings";
      case 4:
        return "Tasks";
      case 5:
        return "Reports";
      default:
        return "Module";
    }
  }

  // Function to get icons for the modules
  IconData getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.book;
      case 1:
        return Icons.comment;
      case 2:
        return Icons.people;
      case 3:
        return Icons.settings;
      case 4:
        return Icons.check_circle;
      case 5:
        return Icons.report;
      default:
        return Icons.apps;
    }
  }
}