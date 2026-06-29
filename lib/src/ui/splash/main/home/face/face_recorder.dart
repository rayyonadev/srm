import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shafmet/src/app_theme/app_colors.dart';
import 'package:shafmet/src/app_theme/app_style.dart';
import '../../../../../widget/face_camera_widget.dart';
import 'confirmation_screen.dart';

class FaceRecorder extends StatefulWidget {
  const FaceRecorder({super.key});

  @override
  State createState() => _FaceRecorderState();
}

class _FaceRecorderState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 87.h, left: 24.w, right: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 38.h,
                    width: 124.w,
                    decoration: BoxDecoration(
                      color: AppColors.textColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 7.h,
                            horizontal: 11.w,
                          ),
                          height: 24.h,
                          width: 24.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.r),
                            color: AppColors.white,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 15,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        Text(
                          "ortga",
                          style: AppStyle.semiBold14(AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 80.h),
          FaceCameraWidget(
            onCapture: (photoPath) {
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ConfirmationScreen(
                    photoPath: photoPath,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}