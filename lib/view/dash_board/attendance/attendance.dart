import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  static const String id = '\attendanceScreen';
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();





  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Attendance screen')

        ],
      ),
    );
  }
}