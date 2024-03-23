import 'package:cloud_firestore/cloud_firestore.dart';

const TEACHER = 'Teachers';

class TeacherController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getTeacherData() {
    return _firestore.collection(TEACHER).snapshots();
  }
}
