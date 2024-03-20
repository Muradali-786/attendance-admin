import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  static const String id = '\settingScreen';
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();





  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Setting screen')

        ],
      ),
    );
  }
}