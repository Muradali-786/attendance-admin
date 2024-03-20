import 'package:flutter/material.dart';

class ClassesScreen extends StatefulWidget {
  static const String id = '\classesScreen';
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();





  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Classes screen')

        ],
      ),
    );
  }
}