import 'package:attendance_admin/model/class_model.dart';
import 'package:attendance_admin/utils/component/dialoge_boxes/delete_confirmations.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text('Course Information',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColor.kPrimaryColor)),
              ),
              IconButton(onPressed: (){
                registerNewClassDialog(context);
              }, icon: Icon(Icons.add_circle,color: AppColor.kSecondaryColor,)),
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
                return  Text(
                  'No Class Available to show.',
                );
              } else {
                List<ClassInputModel> snap = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return ClassInputModel.fromMap(data);
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
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(snap[index].subjectName.toString()),
                                      Text(
                                          "${snap[index].departmentName}-(${snap[index].batchName})"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomButton(
                                        title: 'Update',
                                        onTap: () {
                                          updateClassValueDialog(
                                              context, snap[index]);
                                        },
                                        kcolor: AppColor.kPrimaryColor),
                                    CustomButton(
                                        title: 'Delete',
                                        onTap: () {
                                          showDeleteClassConfirmationDialog(
                                              context, snap[index]);
                                        },
                                        kcolor: AppColor.kSecondaryColor),
                                  ],
                                ))
                              ],
                            )),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
