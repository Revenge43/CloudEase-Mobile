import 'package:flutter/material.dart';

class Teachers extends StatefulWidget {
  const Teachers({super.key});

  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Teachers Screen'),
      ),
    );
  }
}