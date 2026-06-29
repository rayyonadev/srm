import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shafmet/src/app_theme/app_colors.dart';
import 'package:shafmet/src/app_theme/app_style.dart';
import 'face_recorder.dart';

class FaceIdScreen extends StatefulWidget {
  const FaceIdScreen({super.key});

  @override
  State<FaceIdScreen> createState() => _FaceIdScreenState();
}

class _FaceIdScreenState extends State<FaceIdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('salom', style: AppStyle.medium16(AppColors.textGrey)),
                      SizedBox(height: 6.h),
                      Text('javohir',
                          style: AppStyle.semiBold20(AppColors.textColor)
                              .copyWith(fontSize: 20.sp)),
                    ],
                  ),
                  SizedBox(
                    width: 72.w,
                    height: 67.w,
                    child: Image.asset("assets/images/shafmet.png",
                        fit: BoxFit.contain, color: AppColors.blueBg),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              /// KARTA
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Icon + Sarlavha
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26.r,
                          backgroundColor: const Color(0xFF1A1A1A),
                          child: Icon(Icons.cleaning_services_rounded,
                              color: Colors.white, size: 24.sp),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tozalikga Rioya Qilish',
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A1A))),
                            Text('Hududiy tozalik',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    Text(
                      'Hududiy tozalik rioya qilish va foto\notchot qilish va pul ishlash',
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey, height: 1.5),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      'briktrilgan hududni artip chiqing !',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade400,
                          fontStyle: FontStyle.italic),
                    ),

                    SizedBox(height: 20.h),

                    Text(
                      "Sizga Bonus : 5 000 so'm",
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blueBg),
                    ),

                    SizedBox(height: 60.h),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              /// TUGMA
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FaceRecorder(),
                        ),
                      );
                    },
                    icon: Icon(Icons.camera_alt_rounded,
                        color: Colors.white, size: 20.sp),
                    label: Text('Rasmga olish',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueBg,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}