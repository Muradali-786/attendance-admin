class SignUpModel {
  String? teacherId;
  final String name;
  final String email;
  final bool status;
  final String courseLoad;
  final String totalCreditHour;

  SignUpModel({
    this.teacherId,
    required this.name,
    required this.email,
    this.status=true,
    this.courseLoad = '0',
    this.totalCreditHour = '0',
  });

  SignUpModel.fromMap(Map<String, dynamic> res)
      : teacherId = res['teacherId'],
        name = res['name'],
        email = res['email'],
        status=res['status'],
        courseLoad = res['courseLoad'],
        totalCreditHour = res['totalCreditHour'];

  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'name': name,
      'email': email,
      'status':status,
      'courseLoad': courseLoad,
      'totalCreditHour': totalCreditHour,
    };
  }
}