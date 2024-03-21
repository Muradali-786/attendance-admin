
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constant/app_style/app_styles.dart';
import '../../model/attendance_model.dart';
import '../../utils/utils.dart';

class AttendanceController extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  bool _loading = false;
  bool get loading => _loading;

  List<String> _attendanceStatus = [];
  List<String> get attendanceStatus => _attendanceStatus;

  Map<dynamic, dynamic>? _updatedStatusMap;
  Map<dynamic, dynamic>? get updatedStatusMap => _updatedStatusMap;

  void setStatusMap(Map data) {
    _updatedStatusMap = data;
    notifyListeners();
  }

  attendanceStatusProvider(int length) {
    _attendanceStatus = List.generate(length, (index) => "P");
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> saveAllStudentAttendance(AttendanceModel model) async {
    setLoading(true);
    try {
      String docId = _fireStore
          .collection(CLASS)
          .doc(model.classId)
          .collection(ATTENDANCE)
          .doc()
          .id;
      model.attendanceId = docId;

      await _fireStore
          .collection(CLASS)
          .doc(model.classId)
          .collection(ATTENDANCE)
          .doc(docId)
          .set(model.toMap())
          .then((value) {
        updateAttendanceCount(model.classId).then((value) {
          setLoading(false);
        });
      });

      setLoading(false);
      Utils.toastMessage('Attendance Taken');
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error recording attendance: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateStudentAttendance(AttendanceModel model) async {
    setLoading(true);
    try {
      await _fireStore
          .collection(CLASS)
          .doc(model.classId)
          .collection(ATTENDANCE)
          .doc(model.attendanceId)
          .update(model.toMap())
          .then((value) {
        setLoading(false);
        Utils.toastMessage('Attendance Updated');
      });
      setLoading(false);
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error updating attendance: ${e.toString()}');
    }
  }

  Future<void> deleteAttendanceRecord(String subjectId, String attnId) async {
    try {
      await _fireStore
          .collection(CLASS)
          .doc(subjectId)
          .collection(ATTENDANCE)
          .doc(attnId)
          .delete()
          .then((value) {
        Utils.toastMessage('Attendance deleted');
      });
    } catch (e) {
      Utils.toastMessage('Error deleting attendance: ${e.toString()}');
    }
  }

  Stream<QuerySnapshot> getAllStudentAttendance(String subjectId) {
    return _fireStore
        .collection(CLASS)
        .doc(subjectId)
        .collection(ATTENDANCE).orderBy('selectedDate',descending: false)
        .snapshots();
  }
  Stream<QuerySnapshot> getAllStudentAttendanceBySelectedDate(String subjectId,DateTime date) {
    return _fireStore
        .collection(CLASS)
        .doc(subjectId)
        .collection(ATTENDANCE).where('electedDate',isEqualTo:date)
        .snapshots();
  }

  Future<QuerySnapshot> getAllStudentAttendanceToExport(String subjectId) {
    return _fireStore
        .collection(CLASS)
        .doc(subjectId)
        .collection(ATTENDANCE).orderBy('selectedDate',descending: false)
        .get();
  }

  Stream<QuerySnapshot> getAllStudentAttendanceByTime(String subjectId) {
    return _fireStore
        .collection(CLASS)
        .doc(subjectId)
        .collection(ATTENDANCE)
        .orderBy('currentTime', descending: true)
        .snapshots();
  }

  Future<int> getAttendanceCount(String classId) async {
    final attendanceCollection =
    _fireStore.collection(CLASS).doc(classId).collection(ATTENDANCE);
    final querySnapshot = await attendanceCollection.get();

    return querySnapshot.docs.length;
  }

  Future<void> updateAttendanceCount(String classId) async {
    setLoading(true);
    try {
      final classDoc = _fireStore.collection(CLASS).doc(classId);
      final count = await getAttendanceCount(classId);
      await classDoc.update({'totalClasses': count}).then((value) {
        setLoading(false);
      });
      setLoading(false);
    } catch (e) {
      setLoading(false);
    }
  }

  void updateStatusList(int index) {
    if (_attendanceStatus[index] == 'P') {
      _attendanceStatus[index] = 'A';
    } else if (_attendanceStatus[index] == 'A') {
      _attendanceStatus[index] = 'L';
    } else {
      _attendanceStatus[index] = 'P';
    }
    notifyListeners();
  }

  void updateStatusListBasedOnKey(String index) {
    if (_updatedStatusMap![index] == 'P') {
      _updatedStatusMap![index] = 'A';
    } else if (_updatedStatusMap![index] == 'A') {
      _updatedStatusMap![index] = 'L';
    } else {
      _updatedStatusMap![index] = 'P';
    }
    notifyListeners();
  }
}