import 'package:flutter/material.dart';
import '../../constant/app_style/app_colors.dart';

class CustomRoundButton extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final VoidCallback onPress;
  final Color buttonColor;
  final bool loading;

  const CustomRoundButton({
    Key? key,
    required this.title,
    required this.onPress,
    required this.buttonColor,
    this.width = 150,
    this.height = 50,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: loading
            ? const Center(
          child: CircularProgressIndicator(
            color: AppColor.kWhite,
          ),
        )
            : Center(
          child: Text(
            title,
            style:TextStyle( fontSize: 14,color: AppColor.kTextWhiteColor,fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final Color kcolor;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.kcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 25,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: kcolor,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: kcolor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
