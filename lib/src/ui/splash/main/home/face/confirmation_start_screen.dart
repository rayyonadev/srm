import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shafmet/src/app_theme/app_colors.dart';
import 'package:shafmet/src/app_theme/app_style.dart';
import 'package:shafmet/src/ui/splash/main/main_screen.dart';

class ConfirmationStartScreen extends StatefulWidget {
  const ConfirmationStartScreen({super.key});

  @override
  State<ConfirmationStartScreen> createState() => _ConfirmationStartScreenState();
}

class _ConfirmationStartScreenState extends State<ConfirmationStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/image.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 82.h,
            left:52.w,
            right: 52.w,
            child: GestureDetector(
              onTap: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=> MainScreen()), (route)=>false);
              },
              child: Container(
                height: 53.h,
                decoration: BoxDecoration(
                  color: AppColors.blueBg,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Center(
                  child: Text(
                    "ish boshlash",
                    style: AppStyle.semiBold14(AppColors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
