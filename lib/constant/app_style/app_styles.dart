import 'package:flutter/material.dart';



class AppStyles{

  TextStyle defaultStyle(double size, Color color, FontWeight fw) {
    return TextStyle(
       // Replace 'MyCustomFont' with the actual font name
      fontSize: size,
      color: color,
      fontWeight: fw,
    );
  }

  TextStyle defaultStyleWithHt(double size, Color color, FontWeight fw, double ht) {
    return TextStyle(
      // Replace 'MyCustomFont' with the actual font name
        fontSize: size,
        color: color,
        fontWeight: fw,
        height: ht);
  }
}



// firebase COLLECTION NAMES
 const String TEACHER = 'Teachers';
const String CLASS = 'Classes';
//Subs collections of CLASS
const String STUDENT = 'Students';
const String ATTENDANCE = 'Attendance';