// lib/features/home/screens/course/modules_screen.dart
import 'package:flutter/material.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  // Track the expanded state of each module

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Module 0
          ExpansionTile(
            title: const Text('Module 0: Getting Started'),
            collapsedBackgroundColor: const Color.fromARGB(255, 249, 245, 231),
            childrenPadding: const EdgeInsets.only(bottom: 10),
            children: [
              Card(
                elevation: 2,
                child: ListTile(
                  title: const Text('0.1 Welcome Letter', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('View'),
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  onTap: () {
                    // Handle module tap
                  },
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: ListTile(
                  title: const Text('Module 2: State Management', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Viewed'),
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  onTap: () {
                    // Handle module tap
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Module 1
          ExpansionTile(
            title: const Text('Module 1: Course Resources'),
            collapsedBackgroundColor: const Color.fromARGB(255, 249, 245, 231),
            childrenPadding: const EdgeInsets.only(bottom: 10),
            children: [
              Card(
                elevation: 2,
                child: ListTile(
                  title: const Text('Course Orientation.pdf', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('View'),
                  trailing: const Text('File'),
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  onTap: () {
                    // Handle module tap
                  },
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: ListTile(
                  title: const Text('Titles with Prototype', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Aug 27 20 pts'),
                  trailing: const Text('Submit'),
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  onTap: () {
                    // Handle module tap
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}