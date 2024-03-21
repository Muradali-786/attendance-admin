import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:attendance_admin/view/dash_board/teacher_info.dart';
import 'package:attendance_admin/view/dash_board/my_file.dart';

import 'package:flutter/material.dart';

import '../../responsive.dart';
import 'graph_charts_statistic.dart';

class DashboardScreen extends StatelessWidget {
  static const String id = '\dashboard';
  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
         
              child:  Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColor.kPrimaryColor
                )
              ),
            ),

            // SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(),
                      SizedBox(height: 16),
                      TeacherInformation(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: 16),
                      if (Responsive.isMobile(context)) GraphChartsStatistic(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: 16),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: GraphChartsStatistic(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}



class ProfileManagementScreen extends StatefulWidget {
  static const String id = '\ProfileManagementScreen';

  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() => _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Manage Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


