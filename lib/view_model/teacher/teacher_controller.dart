import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../model/sign_up_model.dart';
import '../../utils/utils.dart';

const TEACHER = 'Teachers';

class TeacherController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = false;
  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Stream<QuerySnapshot> streamTeacherData() {
    return _firestore.collection(TEACHER).snapshots();
  }

  Future<QuerySnapshot> getTeacherData() {
    return _firestore.collection(TEACHER).get();
  }

  Future<QuerySnapshot> getSingleTeacherData(String teacherId) {
    return _firestore
        .collection(TEACHER)
        .where('teacherId', isEqualTo: teacherId)
        .get();
  }

  Future<void> deleteTeacherData() async {
    dynamic data = await _auth.userChanges().toList();
  }

  Future<void> registerTeacher(SignUpModel signUpModel, String password) async {
    setLoading(true);
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: signUpModel.email, password: password)
          .then((e) {
        signUpModel.teacherId = e.user!.uid;
        saveTeacherData(signUpModel).then((value) {
          setLoading(false);
        });
        setLoading(false);
        Utils.toastMessage('register Successful');
      });
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('error during signup');
    }
  }

  Future<void> saveTeacherData(SignUpModel signUpModel) async {
    try {
      await _firestore
          .collection(TEACHER)
          .doc(signUpModel.teacherId)
          .set(signUpModel.toMap())
          .then((value) {
        print('successfully save data of teacher');
      });
    } catch (e) {
      print('error while storing  teacher data ');
    }
  }
}
