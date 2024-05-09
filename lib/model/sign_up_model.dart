class SignUpModel {
  String? teacherId;
  final String name;
  final String email;
  final String courseLoad;
  final String totalCreditHour;

  SignUpModel({
    this.teacherId,
    required this.name,
    required this.email,
    this.courseLoad = '0',
    this.totalCreditHour = '0',
  });

  SignUpModel.fromMap(Map<String, dynamic> res)
      : teacherId = res['teacherId'],
        name = res['name'],
        email = res['email'],
        courseLoad = res['courseLoad'],
        totalCreditHour = res['totalCreditHour'];

  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'name': name,
      'email': email,
      'courseLoad': courseLoad,
      'totalCreditHour': totalCreditHour,
    };
  }
}