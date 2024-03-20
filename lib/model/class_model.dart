class ClassInputModel {
  String? subjectId;
  final String? subjectName;
  final String? teacherId;
  final String? departmentName;
  final String? batchName;
  final int? percentage;
  final int totalClasses;

  ClassInputModel({
    this.subjectId,
    this.totalClasses = 0,
    required this.subjectName,
    required this.teacherId,
    required this.departmentName,
    required this.batchName,
    required this.percentage,
  });
  ClassInputModel.fromMap(Map<dynamic, dynamic> res)
      : subjectId = res['subjectId'],
        subjectName = res['subjectName'],
        teacherId = res['teacherId'],
        departmentName = res['departmentName'],
        batchName = res['batchName'],
        percentage = res['percentage'],
        totalClasses = res['totalClasses'] ?? 0;

  Map<String, Object?> toMap() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'teacherId': teacherId,
      'departmentName': departmentName,
      'batchName': batchName,
      'percentage': percentage,
      'totalClasses': totalClasses,
    };
  }
}
