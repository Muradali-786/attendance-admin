import 'package:flutter/material.dart';

class StudentScreen extends StatefulWidget {
  static const String id = '\studentsScreen';
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();





  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Students screen')

        ],
      ),
    );
  }
}