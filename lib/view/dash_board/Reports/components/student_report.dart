import 'package:flutter/material.dart';
import '../../../../constant/app_style/app_colors.dart';
import '../../../../model/single_std_info_model.dart';
import '../../../../view_model/add_students/students_controller.dart';



class StudentReport extends StatefulWidget {
  const StudentReport({super.key});

  @override
  State<StudentReport> createState() => _StudentReportState();
}

class _StudentReportState extends State<StudentReport> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<OneStudentInfoModel>>(
          future: StudentController().getStudentsDetailsInAllSubject('20'),
          builder: (BuildContext context,
              AsyncSnapshot<List<OneStudentInfoModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Display a loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text(
                  'Error: ${snapshot.error}'); // Display an error message if an error occurs
            } else {
              return Column(
                children: [
                  Text('Student Information'),
                  DataTable(
                    showCheckboxColumn: true,
                    headingRowColor: MaterialStateColor.resolveWith(
                            (states) => AppColor.kSecondaryColor),
                    dataRowColor: MaterialStateColor.resolveWith(
                            (states) => AppColor.kWhite),
                    dividerThickness: 2.0,
                    border: TableBorder.all(color: AppColor.kGrey, width: 2),
                    columns: [
                      _dataColumnText('S.No'),
                      _dataColumnText('Subject'),
                      _dataColumnText('Std Name'),
                      _dataColumnText('Std RollNo'),
                      _dataColumnText('T.Classes'),
                      _dataColumnText('Attended'),
                      _dataColumnText('Std %'),
                    ],
                    rows: snapshot.data!.map((course) {
                      ++index;
                      return DataRow(
                        cells: [
                          _dataCellText(index.toString()),
                          _dataCellText(course.subjectName.toString()),
                          _dataCellText(course.studentName.toString()),
                          _dataCellText(course.studentRollNo.toString()),
                          _dataCellText(course.totalClasses.toString()),
                          _dataCellText(course.totalPresent.toString()),
                          _dataCellText("${course.attendancePercentage}%"),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              );
            }
          },
        )
      ],
    );
  }

  DataCell _dataCellText(String title) {
    return DataCell(
      Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: AppColor.kPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  DataColumn _dataColumnText(String title) {
    return DataColumn(
      tooltip: title,
      label: Text(
        title,
        style: const TextStyle(
            color: AppColor.kWhite, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
