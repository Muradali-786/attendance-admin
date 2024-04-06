import 'package:attendance_admin/model/class_model.dart';
import 'package:attendance_admin/model/student_model.dart';
import 'package:attendance_admin/view_model/add_students/students_controller.dart';
import 'package:attendance_admin/view_model/class_input/class_controller.dart';
import 'package:attendance_admin/view_model/teacher/teacher_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constant/app_style/app_colors.dart';
import '../../../model/sign_up_model.dart';

class StudentScreen extends StatefulWidget {
  static const String id = '\studentsScreen';
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String? onTeacherSelect;
  String? onSubjectSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text('Students Information',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColor.kPrimaryColor)),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add_circle,
                  color: AppColor.kSecondaryColor,
                )),
          ],
        ),
        Container(
          height: 40,
          width: double.infinity,
          decoration:
              BoxDecoration(border: Border.all(color: AppColor.kPrimaryColor)),
          child: Row(
            children: [
              Expanded(
                child: TeacherDropdown(
                  value: onTeacherSelect,
                  onChanged: (String? newValue) {
                    setState(() {
                      onTeacherSelect = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: SubjectDropdown(
                value: onSubjectSelect,
                onChanged: (String? newValue) {
                  setState(() {
                    onSubjectSelect = newValue;

                  });
                },
                teacherId: onTeacherSelect.toString(),
              ))
            ],
          ),
        ),
        FutureBuilder<QuerySnapshot>(
          future: StudentController()
              .getAllStudentDataByClassId(onSubjectSelect.toString()),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('loading');
            } else if (snapshot.hasError) {
              return Text('Error');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No Student has been added in the class.',
                ),
              );
            } else {
              List<StudentModel> snap = snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return StudentModel.fromMap(data);
              }).toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: snap.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColor.kWhite,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.kBlack.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 1.5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snap[index].studentName),
                                  Text(snap[index].studentRollNo),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snap[index].studentName),
                                  Text(snap[index].studentRollNo),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

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
  final String? value;
  final ValueChanged<String?> onChanged;
  final String teacherId;

  const SubjectDropdown({
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
          } else {
            List<ClassInputModel> snap = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return ClassInputModel.fromMap(data);
            }).toList();
            String? initialValue = snap.isNotEmpty ? snap[0].subjectId : null;
            return DropdownButton<String>(
              items: snap.map((ClassInputModel model) {
                return DropdownMenuItem<String>(
                  value: model.subjectId,
                  child: Text(model.subjectName.toString()),
                );
              }).toList(),
              onChanged: onChanged,
              value: value ?? initialValue,
              hint: Text('Select a subject',
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
