import 'package:flutter/material.dart';

import '../../../../constant/app_style/app_colors.dart';
import '../../../../model/class_model.dart';
import '../../../../utils/component/custom_button.dart';
import '../../../../utils/component/dialog_text_field.dart';
import '../../../../utils/utils.dart';
import '../../../../view_model/class_input/class_controller.dart';

Future<void> updateClassValueDialog(BuildContext context,ClassInputModel model) async {
  final formKey = GlobalKey<FormState>();
  TextEditingController subjectController =
  TextEditingController(text: model.subjectName);
  FocusNode subjectFocus = FocusNode();
  TextEditingController departmentController =
  TextEditingController(text: model.departmentName);
  FocusNode departmentFocus = FocusNode();
  TextEditingController batchController =
  TextEditingController(text: model.batchName);
  FocusNode batchFocus = FocusNode();
  TextEditingController attendancePercentageController =
  TextEditingController(text: model.percentage.toString());
  FocusNode attendanceFocus = FocusNode();

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height:40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: AppColor.kSecondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Text(
                      'Edit Class',
                      style:TextStyle(fontSize: 22,color: AppColor.kWhite),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: AppColor.kWhite,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                        key: formKey,
                        child: Column(children: [
                          DialogInputTextField(
                              labelText: 'Subject',
                              myController: subjectController,
                              focusNode: subjectFocus,
                              onFieldSubmittedValue: (val) {
                                Utils.onFocusChange(
                                    context, subjectFocus, departmentFocus);
                              },
                              hint: 'Subject',
                              onValidator: (val) {
                                if (val.isEmpty) {
                                  return 'Please enter a subject';
                                } else if (val.length < 3) {
                                  return 'Subject cannot contain special characters';
                                } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val)) {
                                  return 'Subject cannot contain special characters';
                                }
                                return null;
                              },
                              keyBoardType: TextInputType.text),
                          DialogInputTextField(
                              labelText: 'Department',
                              myController: departmentController,
                              focusNode: departmentFocus,
                              onFieldSubmittedValue: (val) {
                                Utils.onFocusChange(
                                    context, departmentFocus, batchFocus);
                              },
                              hint: 'Department',
                              onValidator: (val) {
                                if (val.isEmpty) {
                                  return 'Please enter a department';
                                } else if (val.length < 2) {
                                  return 'Subject must be at least 2 characters long';
                                } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val)) {
                                  return 'Department cannot contain special characters';
                                }
                                return null;
                              },
                              keyBoardType: TextInputType.text),
                          DialogInputTextField(
                              labelText: 'Standard/Batch',
                              myController: batchController,
                              focusNode: batchFocus,
                              onFieldSubmittedValue: (val) {
                                Utils.onFocusChange(
                                    context, batchFocus, attendanceFocus);
                              },
                              hint: 'Standard/Batch',
                              onValidator: (val) {
                                if (val.isEmpty) {
                                  return 'Please enter a Semester/Batch';
                                } else if (val.length < 4) {
                                  return 'Semester/Batch must be at least 4 characters long';
                                } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val)) {
                                  return 'Semester/Batch cannot contain special characters';
                                }

                                return null;
                              },
                              keyBoardType: TextInputType.text),
                          DialogInputTextField(
                              labelText: 'Attendance Requirement(%)',
                              myController: attendancePercentageController,
                              focusNode: attendanceFocus,
                              onFieldSubmittedValue: (val) {},
                              hint: 'Attendance Requirement(%)',
                              onValidator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter attendance percentage.';
                                } else if (double.tryParse(val) == null) {
                                  return 'Please enter a valid number.';
                                } else if (double.parse(val) >= 100 ||
                                    double.parse(val) < 10) {
                                  return 'Enter attendance (10% - 100%)';
                                }
                                return null;
                              },
                              keyBoardType: TextInputType.number),
                        ],))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 22, 30, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: CustomRoundButton(
                          height: 32,
                          title: 'CLOSE',
                          onPress: () {
                            Navigator.pop(context);
                          },
                          buttonColor: AppColor.kSecondaryColor),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: CustomRoundButton(
                        height: 32,
                        title: 'UPDATE',
                        onPress: () async {

                          if (formKey.currentState!.validate()){
                            Navigator.pop(context);
                            ClassInputModel classInputModel = ClassInputModel(
                              subjectName: subjectController.text,
                              teacherId: model.teacherId,
                              subjectId: model.subjectId,
                              totalClasses: model.totalClasses,
                              departmentName: departmentController.text,
                              batchName: batchController.text,
                              percentage:
                              int.tryParse(attendancePercentageController.text),
                            );

                            await ClassController()
                                .updateClassData(classInputModel);
                          }

                        },
                        buttonColor: AppColor.kSecondaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}