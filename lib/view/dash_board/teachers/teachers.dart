import 'package:attendance_admin/constant/app_style/app_styles.dart';
import 'package:attendance_admin/model/sign_up_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeachersScreen extends StatefulWidget {
  static const String id = '\teachersScreen';
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore=FirebaseFirestore.instance;





  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection(TEACHER).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading');
            } else if (snapshot.hasError) {
              return Text('Error');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No Teacher has been added in the class.',
                ),
              );
            } else {
              List<SignUpModel> snap = snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;
                return SignUpModel.fromMap(data);
              }).toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: snap.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snap[index].name),
                      subtitle: Text(snap[index].name),
                    );
                  },
                ),
              );
            }
          },
        ),

      ],
    );
  }
}