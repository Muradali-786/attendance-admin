import 'dart:io';
import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:attendance_admin/text_theme.dart';
import 'package:attendance_admin/view/side_menu/side_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? const FirebaseOptions(
              apiKey: "AIzaSyCGFzozTh1w79r1R2WJB79fg1f82ZJ-zOA",
              appId: "1:868175613153:android:6992370f24caf82278fba0",
              messagingSenderId: "868175613153",
              projectId: "attendance-manager-4e159",
            )
          : null);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CS Admin Panel',
      theme: ThemeData(
        textTheme: textTheme,
        canvasColor: AppColor.kBlueColor,
      ),

      home: const SideMenu(),
      builder: EasyLoading.init(),
    );
  }
}
