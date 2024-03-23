import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant/app_style/app_styles.dart';
import '../../model/class_model.dart';
import '../../utils/utils.dart';

class ClassController with ChangeNotifier {
  final fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = false;
  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> createNewClass(ClassInputModel classInputModel) async {
    setLoading(true);
    try {
      String docId = fireStore.collection(CLASS).doc().id;
      classInputModel.subjectId = docId;

      await fireStore
          .collection(CLASS)
          .doc(docId)
          .set(classInputModel.toMap())
          .then(
        (value) {
          setLoading(false);
        },
      );

      setLoading(false);

      Utils.toastMessage('Class created successfully');
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error creating class');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateClassData(ClassInputModel classInputModel) async {
    setLoading(true);
    try {
      await fireStore
          .collection(CLASS)
          .doc(classInputModel.subjectId)
          .update(classInputModel.toMap());
      setLoading(false);

      Utils.toastMessage('Class Updated');
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error While Updating updating class data');
    }
  }

  Stream<QuerySnapshot> getAllClassesData() {
    return fireStore.collection(CLASS).snapshots();
  }

  Future<void> deleteClass(String classId) async {
    try {
      await fireStore.collection(CLASS).doc(classId).delete();

      Utils.toastMessage('Class deleted successfully');
    } catch (e) {
      Utils.toastMessage('Error deleting class: ${e.toString()}');
    }
  }
}
