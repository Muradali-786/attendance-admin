import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:attendance_admin/constant/app_style/app_styles.dart';
import 'package:attendance_admin/model/sign_up_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({Key? key}) : super(key: key);

  @override
  State<RecentFiles> createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.kSecondaryColor,
        borderRadius:  BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Teachers Information",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: AppColor.kTextWhiteColor),
          ),
          SizedBox(
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection(TEACHER).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColor.kSecondaryColor,));
                } else if (snapshot.hasError) {
                  return Text('Error Occur${snapshot.hasError.toString()}');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Teacher has been added in the class.',
                    ),
                  );
                } else {
                  List<SignUpModel> snap = snapshot.data!.docs
                      .map((doc) => SignUpModel.fromMap(
                          doc.data() as Map<String, dynamic>))
                      .toList();

                  return DataTable(
                    columnSpacing: 16,
                    columns: [
                      DataColumn(
                        label: Text(
                          "Name",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Email",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Last Active",

                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    rows:
                        snap.map((model) => recentFileDataRow(model)).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(SignUpModel model) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                model.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: AppColor.kWhite),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(
        model.email,
        style: TextStyle(color: AppColor.kWhite),
      )),
      DataCell(Text(
        '12:00 PM',
        style: TextStyle(color: AppColor.kWhite),
      )),
    ],
  );
}
