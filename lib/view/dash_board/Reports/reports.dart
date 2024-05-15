import 'package:attendance_admin/model/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constant/app_style/app_colors.dart';

import '../../../model/class_model.dart';
import '../../../model/print_std_model.dart';
import '../../../model/student_model.dart';
import '../../../utils/component/custom_button.dart';
import '../../../utils/component/dialoge_boxes/delete_confirmations.dart';
import '../../../utils/component/std_and_teacher_drop_down.dart';
import '../../../view_model/add_students/students_controller.dart';
import '../../../view_model/attendance/attendance_controller.dart';
import '../../../view_model/class_input/class_controller.dart';
import '../classes/import/import_dialog_box.dart';
import '../classes/update/updae_class_dialog.dart';

class Reports extends StatefulWidget {
  static const String id = '\Reports';
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Reports',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.kPrimaryColor,
                ),
              ),
            ),
            ReportDropdown(),
          ],
        ),
      ),
    );
  }

  DataCell _dataCellText(String title) {
    return DataCell(
      Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: AppColor.kPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  DataColumn _dataColumnText(String title) {
    return DataColumn(
      tooltip: title,
      label: Text(
        title,
        style: const TextStyle(
            color: AppColor.kWhite, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class ReportDropdown extends StatefulWidget {
  @override
  _ReportDropdownState createState() => _ReportDropdownState();
}

class _ReportDropdownState extends State<ReportDropdown> {
  String? _selectedReport;
  List<String> _reports = ["Attendance Report", "Student Report"];

  final ClassController _classController = ClassController();
  String? onTeacherSelect;
  String? onSubjectSelect;

  List<String> stdIdList = [];
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime date = DateTime.now();
  List<StudentModel> _students = [];

  void _fetchStudents(String classId) async {
    List<StudentModel> students =
        await StudentController().getAllStudentsFromClass(classId);

    setState(() {
      _students = students;
    });
  }

  String roll = '20';
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButton<String>(
            hint: Text("Select Report"),
            value: _selectedReport,
            onChanged: (newValue) {
              setState(() {
                _selectedReport = newValue;
              });
            },
            items: _reports.map((report) {
              return DropdownMenuItem(
                child: Text(report),
                value: report,
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          if (_selectedReport == "Attendance Report") ...[
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor.kPrimaryColor)),
              child: Row(
                children: [
                  Expanded(
                    child: TeacherDropdown(
                      value: onTeacherSelect,
                      onChanged: (String? newValue) {
                        setState(() {
                          onTeacherSelect = newValue;
                          onSubjectSelect = null;
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
                          _fetchStudents(newValue!);
                        });
                      },
                      teacherId: onTeacherSelect.toString(),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: onSubjectSelect != null
                  ? _classController.getSingleClassesData(onSubjectSelect!)
                  : null,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else if (snapshot.hasError) {
                  return Container();
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container();
                } else {
                  List<ClassInputModel> snap = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return ClassInputModel.fromMap(data);
                  }).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Subject Information'),
                      DataTable(
                        showCheckboxColumn: true,
                        headingRowColor: MaterialStateColor.resolveWith(
                          (states) => AppColor.kSecondaryColor,
                        ),
                        dataRowColor: MaterialStateColor.resolveWith(
                            (states) => AppColor.kWhite),
                        dividerThickness: 2.0,
                        border:
                            TableBorder.all(color: AppColor.kGrey, width: 2),
                        columns: [
                          _dataColumnText('S.No'),
                          _dataColumnText('Name'),
                          _dataColumnText('Batch'),
                          _dataColumnText('Department'),
                          _dataColumnText('Class Sum'),
                          _dataColumnText('Credit-Hrs'),
                          _dataColumnText('Action'),
                        ],
                        rows: snap.map((course) {
                          return DataRow(
                            cells: [
                              _dataCellText('1'),
                              _dataCellText(course.subjectName.toString()),
                              _dataCellText(course.batchName.toString()),
                              _dataCellText(course.departmentName.toString()),
                              _dataCellText(course.totalClasses.toString()),
                              _dataCellText(course.creditHour.toString()),
                              DataCell(Row(
                                children: [
                                  CustomIconButton(
                                    icon: Icons.edit,
                                    tooltip: 'Click the button to edit class.',
                                    onTap: () {
                                      updateClassValueDialog(context, course);
                                    },
                                  ),
                                  CustomIconButton(
                                    icon: Icons.delete,
                                    tooltip:
                                        'Click the button to delete class.',
                                    onTap: () {
                                      showDeleteClassConfirmationDialog(
                                          context, course);
                                    },
                                  ),
                                  CustomIconButton(
                                    icon: Icons.more_vert,
                                    tooltip: 'Click to open the import dialog',
                                    color: AppColor.kPrimaryColor,
                                    onTap: () {
                                      showImportDialog(
                                          context, course.subjectId.toString());
                                    },
                                  )
                                ],
                              ))
                            ],
                          );
                        }).toList(),
                      ),
                      Text('Enrolled Student Information'),
                    ],
                  );
                }
              },
            ),
            FutureBuilder<QuerySnapshot>(
              future: onSubjectSelect != null
                  ? AttendanceController()
                      .fetchAllAttendanceRecord(onSubjectSelect!)
                  : null,
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
                  List<AttendanceModel> snap = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return AttendanceModel.fromMap(data);
                  }).toList();

                  return ListView.builder(
                    itemCount: _students.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String status = snap[index]
                          .attendanceList[_students[index].studentId]
                          .toString();

                      return Row(
                        children: [
                          Text(_students[index].studentRollNo.toString()),
                          Text(_students[index].studentName.toString()),
                          Text(status)
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ] else if (_selectedReport == "Student Report") ...[
            FutureBuilder<List<OneStudentInfoModel>>(
              future: StudentController().getStudentsDetailsInAllSubject('20'),
              builder: (BuildContext context,
                  AsyncSnapshot<List<OneStudentInfoModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Display a loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Display an error message if an error occurs
                } else {
                  return Column(
                    children: [
                      Text('Student Information'),
                      DataTable(
                        showCheckboxColumn: true,
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => AppColor.kSecondaryColor),
                        dataRowColor: MaterialStateColor.resolveWith(
                            (states) => AppColor.kWhite),
                        dividerThickness: 2.0,
                        border: TableBorder.all(color: AppColor.kGrey, width: 2),
                        columns: [
                          _dataColumnText('S.No'),
                          _dataColumnText('Subject'),
                          _dataColumnText('Std Name'),
                          _dataColumnText('Std RollNo'),
                          _dataColumnText('T.Classes'),
                          _dataColumnText('Attended'),
                          _dataColumnText('Std %'),
                        ],
                        rows: snapshot.data!.map((course) {
                          ++index;
                          return DataRow(
                            cells: [
                              _dataCellText(index.toString()),
                              _dataCellText(course.subjectName.toString()),
                              _dataCellText(course.studentName.toString()),
                              _dataCellText(course.studentRollNo.toString()),
                              _dataCellText(course.totalClasses.toString()),
                              _dataCellText(course.totalPresent.toString()),
                              _dataCellText("${course.attendancePercentage}%"),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }
              },
            )
          ],
        ],
      ),
    );
  }

  DataCell _dataCellText(String title) {
    return DataCell(
      Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: AppColor.kPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  DataColumn _dataColumnText(String title) {
    return DataColumn(
      tooltip: title,
      label: Text(
        title,
        style: const TextStyle(
            color: AppColor.kWhite, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
