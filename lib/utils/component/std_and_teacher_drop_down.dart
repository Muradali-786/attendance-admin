import 'package:attendance_admin/model/class_model.dart';
import 'package:attendance_admin/view_model/class_input/class_controller.dart';
import 'package:attendance_admin/view_model/teacher/teacher_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constant/app_style/app_colors.dart';
import '../../../model/sign_up_model.dart';

class TeacherDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const TeacherDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.kPrimaryColor),
      ),
      child: FutureBuilder<QuerySnapshot>(
        future: TeacherController().getTeacherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<SignUpModel> snap = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return SignUpModel.fromMap(data);
            }).toList();
            return DropdownButton<String>(
              items: snap.map((SignUpModel model) {
                return DropdownMenuItem<String>(
                  value: model.teacherId,
                  child: Text(model.name),
                );
              }).toList(),
              onChanged: onChanged,
              value: value,
              hint: Text('Select a Teacher',
                  style: TextStyle(color: AppColor.kBlack)),
              isExpanded: true,
              style: TextStyle(color: AppColor.kBlack),
            );
          }
        },
      ),
    );
  }
}

class SubjectDropdown extends StatelessWidget {
  String? value;
  final ValueChanged<String?> onChanged;
  final String teacherId;

  SubjectDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.teacherId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.kPrimaryColor),
      ),
      child: FutureBuilder<QuerySnapshot>(
        future: ClassController().getClassesDataByTeacherId(teacherId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<ClassInputModel> snap = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return ClassInputModel.fromMap(data);
            }).toList();
            value = snap.isNotEmpty ? snap[0].subjectId : null;
            return DropdownButton<String>(
              items: snap.map((ClassInputModel model) {
                return DropdownMenuItem<String>(
                  value: model.subjectId,
                  child: Text(model.subjectName.toString()),
                );
              }).toList(),
              onChanged: onChanged,
              value: value,
              hint: Text('Select a subject',
                  style: TextStyle(color: AppColor.kBlack)),
              isExpanded: true,
              style: TextStyle(color: AppColor.kBlack),
            );
          } else {
            return Text('Empty');
          }
        },
      ),
    );
  }
}
