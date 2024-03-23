import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:attendance_admin/constant/app_style/app_styles.dart';
import 'package:attendance_admin/model/sign_up_model.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text('Faculty Information',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColor.kPrimaryColor)),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _teacherController.getTeacherData(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShimmerLoadingEffect();
              } else if (snapshot.hasError) {
                return Text('Error');
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No Teacher has been added in the class.',
                  ),
                );
              } else {
                List<SignUpModel> snap = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return SignUpModel.fromMap(data);
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
                                      Text(snap[index].name),
                                      Text(snap[index].email),
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
                                        onTap: () {},
                                        kcolor: AppColor.kPrimaryColor),
                                    CustomButton(
                                        title: 'Delete',
                                        onTap: () {},
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
