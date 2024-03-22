import 'package:attendance_admin/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const ADMIN = 'Admin';

class DashBoardController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String id = '123456';
  Future<void> storeDepartmentStatsInAdmin() async {
    try {
      await _firestore.collection(ADMIN).doc(id).set({
        'totalStudent': '400',
        'totalClasses': '12',
        'totalTeacher': '06',
        'percentage': '87',
        'depCount':'01',
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
