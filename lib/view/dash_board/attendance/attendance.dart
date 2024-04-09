import 'package:attendance_admin/model/student_model.dart';
import 'package:attendance_admin/utils/component/date_picker.dart';
import 'package:attendance_admin/view_model/add_students/students_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constant/app_style/app_colors.dart';
import '../../../constant/app_style/app_styles.dart';
import '../../../model/attendance_model.dart';
import '../../../utils/component/custom_button.dart';
import '../../../utils/component/std_and_teacher_drop_down.dart';
import '../../../utils/component/time_picker.dart';
import '../../../utils/utils.dart';
import '../../../view_model/attendance/attendance_controller.dart';

class AttendanceScreen extends StatefulWidget {
  static const String id = '\attendanceScreen';
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? onTeacherSelect;
  String? onSubjectSelect;
  List<String> stdIdList = [];
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime date = DateTime.now();

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay pickedTime = await showTimePickerDialog(context);

    if (pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime pickedDate = await showDatePickerDialog(context);

    if (pickedDate != date) {
      setState(() {
        date = pickedDate;
      });
    }
  }

  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('yMMMMd');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    String period = selectedTime.hour < 12 ? 'AM' : 'PM';
    String hour = selectedTime.hourOfPeriod.toString().padLeft(2, '0');
    String minute = selectedTime.minute.toString().padLeft(2, '0');
    String currentTime = '$hour:$minute $period';

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: const Text('Attendance Information',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.kPrimaryColor)),
              ),
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
                            onSubjectSelect=null;
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
                      ),
                    ),
                    _saveAttendanceButton(currentTime)
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
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      return StudentModel.fromMap(data);
                    }).toList();

                    return Consumer<AttendanceController>(
                        builder: (context, provider, child) {
                      if (provider.attendanceStatus.length != snap.length) {
                        provider.attendanceStatusProvider(snap.length);
                      }
                      if (stdIdList.length != snap.length) {
                        for (var std in snap) {
                          stdIdList.add(std.studentId!);
                        }
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
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
                            _dataColumnText('Roll No'),
                            _dataColumnText('Name'),
                            _dataColumnText('current Date'),
                            _dataColumnText('current Time'),
                            _dataColumnText('Status'),
                          ],
                          rows: List.generate(
                            snap.length,
                            (index) {
                              return DataRow(
                                cells: [
                                  _dataCellText("${index + 1}"),
                                  _dataCellText(snap[index].studentRollNo),
                                  _dataCellText(snap[index].studentName),
                                  DataCell(Tooltip(
                                    message: 'Click the button to Change the date',
                                    child: TextButton(
                                      onPressed: () {
                                        _selectDate(context);
                                      },
                                      child: Text(
                                        formatDate(date),
                                        style: AppStyles().defaultStyle(
                                          18,
                                          AppColor.kPrimaryColor,
                                          FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )),
                                  DataCell(Tooltip(
                                    message: 'Click the button to Change time',
                                    child: TextButton(
                                      onPressed: () {
                                        _selectTime(context);
                                      },

                                      child: Text(
                                        currentTime.toString(),
                                        style: AppStyles().defaultStyle(
                                          18,
                                          AppColor.kPrimaryColor,
                                          FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )),
                                  DataCell(
                                      CustomStatusChangerButton(
                                        attendanceStatus:
                                            provider.attendanceStatus[index],
                                        onTap: () {
                                          provider.updateStatusList(index);
                                        },
                                      ), onTap: () {
                                    provider.updateStatusList(index);
                                  })
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
  Widget _saveAttendanceButton(currentTime){
    return Consumer<AttendanceController>(builder: (context, provider, child) {
      return CustomRoundButton(
        height: 40,
        title: 'SAVE ATTENDANCE',
        loading: provider.loading,

        onPress: () async {
          if (stdIdList.isNotEmpty && onSubjectSelect.toString() != '') {
            AttendanceModel attendanceModel = AttendanceModel(
              classId: onSubjectSelect!,
              selectedDate: date,
              currentTime: currentTime,
              attendanceList: Map.fromIterables(
                stdIdList,
                provider.attendanceStatus,
              ),
            );

            await provider
                .saveAllStudentAttendance(attendanceModel)
                .then((value) {});

            await StudentController().calculateStudentAttendance(
              onSubjectSelect!,
              stdIdList,
            );
          } else {
            Utils.toastMessage('Please select a subject');
          }
        },
        buttonColor: AppColor.kPrimaryColor,
      );
    });
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
