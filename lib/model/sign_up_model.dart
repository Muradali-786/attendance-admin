class SignUpModel {
  String? teacherId;
  final String name;
  final String email;


  SignUpModel({
    this.teacherId,
    required this.name,
    required this.email,

  });

  SignUpModel.fromMap(Map<dynamic, dynamic> res)
      : teacherId = res['teacherId'],
        name = res['name'],
        email = res['email'];


  Map<String, Object?> toMap() {
    return {
      'teacherId': teacherId,
      'name': name,
      'email': email,
    };
  }
}
