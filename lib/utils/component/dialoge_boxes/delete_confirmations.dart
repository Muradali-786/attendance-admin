import 'package:attendance_admin/view_model/teacher/teacher_controller.dart';
import 'package:flutter/material.dart';

import '../../../constant/app_style/app_colors.dart';
import '../../../model/attendance_model.dart';
import '../../../model/class_model.dart';
import '../../../model/student_model.dart';
import '../../../view_model/add_students/students_controller.dart';
import '../../../view_model/attendance/attendance_controller.dart';
import '../../../view_model/class_input/class_controller.dart';

Future<void> showDeleteClassConfirmationDialog(
    BuildContext context, ClassInputModel model) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete"),
        content: Text(
            "Are you sure you want to delete class ${model.subjectName}(${model.departmentName}-${model.batchName}).\nAll the attendance history for this class will be lost"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "CANCEL",
              style: TextStyle(color: AppColor.kSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              await ClassController().deleteClass(
                  model.subjectId.toString(), model.teacherId.toString());
            },
            child: const Text("DELETE",
                style: TextStyle(color: AppColor.kSecondaryColor)),
          ),
        ],
      );
    },
  );
}

Future<void> showDeleteStudentConfirmationDialog(
    BuildContext context, StudentModel model, String classId) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete"),
        content: Text(
            "Are you sure you want to delete student ${model.studentName}(${model.studentRollNo})\n.All the attendance history for this student will be lost"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "CANCEL",
              style: TextStyle(color: AppColor.kSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              await StudentController()
                  .deleteStudent(model.studentId.toString(), classId);
            },
            child: const Text("DELETE",
                style: TextStyle(color: AppColor.kSecondaryColor)),
          ),
        ],
      );
    },
  );
}

Future<void> showDeleteAttendanceConfirmationDialog(
    BuildContext context, AttendanceModel model, String subjectId) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete"),
        content: Text(
            "Are you sure you want to delete the selected attendance(${model.currentTime})."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "CANCEL",
              style: TextStyle(color: AppColor.kSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await AttendanceController().deleteAttendanceRecord(
                subjectId,
                model.attendanceId!,
              );

              await AttendanceController().updateAttendanceCount(subjectId);

              await StudentController().calculateStudentAttendance(
                  subjectId, model.attendanceList.keys.toList());
            },
            child: const Text("DELETE",
                style: TextStyle(color: AppColor.kSecondaryColor)),
          ),
        ],
      );
    },
  );
}
Future<void> changeStatusConfirmationDialog(
    BuildContext context, String teacherId, bool newStatus) async {
  String statusText = newStatus ? "activate" : "deactivate";
  String titleText = newStatus ? "Activate Account" : "Deactivate Account";

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(titleText),
        content: Text(
            "Are you sure you want to $statusText this account?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "CANCEL",
              style: TextStyle(color: AppColor.kSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await TeacherController().updateTeacherStatus(teacherId, newStatus);
            },
            child: Text(
              statusText.toUpperCase(),
              style: const TextStyle(color: AppColor.kSecondaryColor),
            ),
          ),
        ],
      );
    },
  );
}

