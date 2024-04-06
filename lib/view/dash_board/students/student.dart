import 'package:attendance_admin/model/class_model.dart';
import 'package:attendance_admin/model/student_model.dart';
import 'package:attendance_admin/utils/component/dialoge_boxes/delete_confirmations.dart';
import 'package:attendance_admin/utils/component/dialoge_boxes/update_std_dialog.dart';
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
                      fontSize: 24,
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

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColor.kSecondaryColor,
                    borderRadius: BorderRadius.circular(8)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: true,
                    columns: [
                      _dataColumnText('Roll No'),
                      _dataColumnText('Name'),
                      _dataColumnText('Absent'),
                      _dataColumnText('Leaves'),
                      _dataColumnText('Present'),
                      _dataColumnText('%'),
                      _dataColumnText('Actions'),
                    ],
                    rows: snap
                        .map((student) => DataRow(
                              cells: [
                                _dataCellText(student.studentRollNo),
                                _dataCellText(student.studentName),
                                _dataCellText(student.totalAbsent.toString()),
                                _dataCellText(student.totalLeaves.toString()),
                                _dataCellText(student.totalPresent.toString()),
                                _dataCellText(
                                    student.attendancePercentage.toString()),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColor.kWhite,
                                      ),
                                      onPressed: () {
                                        updateStudentDialog(
                                            context,
                                            onSubjectSelect.toString(),
                                            student);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: AppColor.kWhite,
                                      ),
                                      onPressed: () {
                                        showDeleteStudentConfirmationDialog(
                                            context,
                                            student,
                                            onSubjectSelect.toString());
                                      },
                                    ),
                                  ],
                                ))
                              ],
                            ))
                        .toList(),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  DataCell _dataCellText(String title) {
    return DataCell(
      Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColor.kTextWhiteColor),
      ),
    );
  }

  DataColumn _dataColumnText(String title) {
    return DataColumn(
      label: Text(
        title,
        style: const TextStyle(
            color: AppColor.kWhite, overflow: TextOverflow.ellipsis),
      ),
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
