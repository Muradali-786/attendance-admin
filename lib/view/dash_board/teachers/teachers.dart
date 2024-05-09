import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:attendance_admin/model/sign_up_model.dart';
import 'package:attendance_admin/view/dash_board/classes/register/register_new_class_dialog.dart';
import 'package:attendance_admin/view/dash_board/teachers/register_teacher/register_teacher_dialog.dart';
import 'package:attendance_admin/view_model/teacher/teacher_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../utils/component/custom_button.dart';
import '../../../utils/component/custom_shimmer_effect.dart';

class TeachersScreen extends StatefulWidget {
  static const String id = '\teachersScreen';
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  TeacherController _teacherController = TeacherController();

  @override
  Widget build(BuildContext context) {
    int rowIndex = 0;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text('Faculty Information',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColor.kPrimaryColor)),
                ),
                IconButton(
                    onPressed: () {
                      registerNewTeacherDialog(context);
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: AppColor.kSecondaryColor,
                    )),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _teacherController.streamTeacherData(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  EasyLoading.show(status: 'Loading');
                  return Container();
                } else if (snapshot.hasError) {
                  EasyLoading.dismiss();
                  return Text('Error');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  EasyLoading.dismiss();
                  return const Center(
                    child: Text(
                      'No Teacher has been added in the class.',
                    ),
                  );
                } else {
                  EasyLoading.dismiss();
                  List<SignUpModel> snap = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return SignUpModel.fromMap(data);
                  }).toList();
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
                      border: TableBorder.all(color: AppColor.kGrey, width: 2),
                      columns: [
                        _dataColumnText('S.No'),
                        _dataColumnText('Name'),
                        _dataColumnText('Gmail'),
                        _dataColumnText('Subjects'),
                        _dataColumnText('Credit Sum'),
                        _dataColumnText('Actions'),
                      ],
                      rows: snap.map((teacher) {
                        rowIndex++;
                        return DataRow(
                          cells: [
                            _dataCellText(rowIndex.toString()),
                            _dataCellText(teacher.name),
                            _dataCellText(teacher.email),
                            _dataCellText(teacher.courseLoad),
                            _dataCellText(teacher.totalCreditHour),
                            DataCell(Row(
                              children: [
                                CustomIconButton(
                                  icon: Icons.edit,
                                  tooltip: 'Click the button to edit teacher.',
                                  onTap: () {},
                                ),
                                CustomIconButton(
                                  icon: Icons.delete,
                                  tooltip:
                                      'Click the button to delete teacher.',
                                  onTap: () {},
                                ),
                                CustomIconButton(
                                  icon: Icons.add_circle,
                                  tooltip: 'Click the button to assign class.',
                                  color: AppColor.kPrimaryColor,
                                  onTap: () {
                                    registerNewClassDialog(
                                      context,
                                      teacher.teacherId,
                                    );
                                  },
                                )
                              ],
                            ))
                          ],
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
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
        textAlign: TextAlign.start,
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
