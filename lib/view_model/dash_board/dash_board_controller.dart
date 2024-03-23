import 'package:attendance_admin/utils/utils.dart';
import 'package:attendance_admin/view/dash_board/students/student.dart';
import 'package:attendance_admin/view_model/add_students/students_controller.dart';
import 'package:attendance_admin/view_model/attendance/attendance_controller.dart';
import 'package:attendance_admin/view_model/class_input/class_controller.dart';
import 'package:attendance_admin/view_model/teacher/teacher_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constant/app_style/app_styles.dart';

class DashBoardController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TeacherController _teacherController = TeacherController();
  final AttendanceController _attendanceController = AttendanceController();
  final StudentController _studentController = StudentController();
  final ClassController _classController = ClassController();

  Future<String> getAllTeacherLength() async {
    QuerySnapshot data = await _teacherController.getTeacherData();

    if (data.size != 0) {
      return data.size.toString();
    }
    return '0';
  }

  Future<String> getAllSubjectLength() async {
    QuerySnapshot snapshot = await _classController.getAllClassesData();
    if (snapshot.size != 0) {
      return snapshot.size.toString();
    }
    return '0';
  }

  Future<String> getAllEnrolledStudentLength() async {
    QuerySnapshot snapshot = await _classController.getAllClassesData();
    int totalStudentCount = 0;

    if (snapshot.size != 0) {
      for (QueryDocumentSnapshot classDoc in snapshot.docs) {
        String classId = classDoc.id;
        QuerySnapshot stdSnap =
            await _studentController.getAllStudentCountOfOneClass(classId);

        if (stdSnap.size != 0) {
          int classStudentCount = stdSnap.size;
          totalStudentCount += classStudentCount;
        }
      }
      return totalStudentCount.toString();
    }
    return '0';
  }



  String id = '123456';
  Future<void> storeDepartmentStatsInAdmin() async {
    try {
      await _firestore.collection(ADMIN).doc(id).set({
        'totalStudent': '400',
        'totalClasses': '12',
        'totalTeacher': '06',
        'percentage': '87',
        'depCount': '01',
        'presentStudents': '250',
        'absentStudents': '50',
        'leavesStudents': '100',
      });
      Utils.toastMessage('Data Refresh');
    } catch (e) {
      Utils.toastMessage('Error Occurs While Refreshing States');
    }
  }

  Stream<DocumentSnapshot> getDepartmentStats() {
    return _firestore.collection(ADMIN).doc(id).snapshots();
  }
}
