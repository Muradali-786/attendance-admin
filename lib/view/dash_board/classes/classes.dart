import 'package:attendance_admin/model/class_model.dart';
import 'package:attendance_admin/utils/component/dialoge_boxes/delete_confirmations.dart';
import 'package:attendance_admin/view/dash_board/classes/import/import_dialog_box.dart';
import 'package:attendance_admin/view/dash_board/classes/register/register_new_class_dialog.dart';
import 'package:attendance_admin/view/dash_board/classes/update/updae_class_dialog.dart';
import 'package:attendance_admin/view_model/class_input/class_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constant/app_style/app_colors.dart';
import '../../../utils/component/custom_button.dart';
import '../../../utils/component/custom_shimmer_effect.dart';

class ClassesScreen extends StatefulWidget {
  static const String id = '\classesScreen';
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final ClassController _controller = ClassController();

  @override
  Widget build(BuildContext context) {
    int rowIndex = 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text('Course Information',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColor.kPrimaryColor)),
                ),
                IconButton(
                    onPressed: () {

                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: AppColor.kSecondaryColor,
                    )),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _controller.streamAllClassesData(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ShimmerLoadingEffect();
                } else if (snapshot.hasError) {
                  return Text('Error');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text(
                    'No Class Available to show.',
                  );
                } else {
                  List<ClassInputModel> snap = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return ClassInputModel.fromMap(data);
                  }).toList();
                  return DataTable(
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
                      _dataColumnText('Batch'),
                      _dataColumnText('Department'),
                      _dataColumnText('Course Load'),
                      _dataColumnText('Req %'),
                      _dataColumnText('Actions'),
                    ],
                    rows: snap.map((course) {
                      rowIndex++;
                      return DataRow(
                        cells: [
                          _dataCellText(rowIndex.toString()),
                          _dataCellText(course.subjectName.toString()),
                          _dataCellText(course.batchName.toString()),
                          _dataCellText(course.departmentName.toString()),
                          _dataCellText(course.totalClasses.toString()),
                          _dataCellText("${course.percentage}%"),
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
                                icon:   Icons.more_vert,
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
