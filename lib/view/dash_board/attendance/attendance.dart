import 'package:attendance_admin/model/student_model.dart';
import 'package:attendance_admin/view_model/add_students/students_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_style/app_colors.dart';
import '../../../constant/app_style/app_styles.dart';
import '../../../view_model/attendance/attendance_controller.dart';
import '../students/student.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text('Attenddance Information',
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
            }else {
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

                    return Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
                          if (stdIdList.length != snap.length) {
                            stdIdList.add(snap[index].studentId!);
                          }

                          return CustomAttendanceList(
                              stdName: snap[index].studentName,
                              stdRollNo: snap[index].studentRollNo,
                              attendanceStatus:
                              provider.attendanceStatus[index],
                              onTap: () {
                                provider.updateStatusList(index);
                              });
                        },
                      ),
                    );
                  });
            }
          },
        ),
      ],
    );
  }
}


class CustomAttendanceList extends StatelessWidget {
  final String stdName, stdRollNo, attendanceStatus;
  final VoidCallback onTap;

  const CustomAttendanceList({
    super.key,
    required this.stdName,
    required this.stdRollNo,
    required this.attendanceStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 17),
        width: double.infinity,
        height: 70,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stdName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles().defaultStyle(
                      22,
                      AppColor.kTextBlackColor,
                      FontWeight.w400,
                    ),
                  ),
                  Text(
                    stdRollNo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles().defaultStyleWithHt(
                      17,
                      AppColor.kTextGreyColor,
                      FontWeight.normal,
                      1.5,
                    ),
                  ),
                ],
              ),),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 53,
                    width: 65,
                    decoration: BoxDecoration(
                      color: getStatusColor(attendanceStatus),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: Text(
                        attendanceStatus,
                        style: AppStyles().defaultStyle(
                          32,
                          AppColor.kTextWhiteColor,
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),)
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'A':
        return AppColor.kSecondaryColor;
      case 'L':
        return AppColor.kSecondary54Color;
      default:
        return AppColor.kPrimaryTextColor;
    }
  }
}

