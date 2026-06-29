import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shafmet/src/app_theme/app_colors.dart';
import 'package:shafmet/src/app_theme/app_style.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      Text(
                        'salom',
                        style: AppStyle.medium16(AppColors.textGrey),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'javohir',
                        style: AppStyle.semiBold20(AppColors.textColor)
                            .copyWith(fontSize: 20.sp),
                      ),
                    ],
                  ),
                  Container(
                    width:72.w,
                    height: 67.w,
                    child:Image.asset("assets/images/shafmet.png",fit: BoxFit.cover,color: AppColors.blueBg,),
                  ),
                ],
              ),
              SizedBox(height: 54.h),

              /// NOTIFICATION CARDS
              NotificationItemWidget(
                title: 'Ertalabki Topshriq Bajarlidi',
                amount: '+5 000 so`m',
                amountColor: AppColors.green,
              ),

              SizedBox(height: 14.h),

              NotificationItemWidget(
                title: 'kunlik topshriq bajarildi',
                amount: '+2 000 so`m',
                amountColor: AppColors.green,
              ),

              SizedBox(height: 14.h),

              NotificationItemWidget(
                title: 'Ishga Kech Kelindi',
                amount: '-20 000 so`m',
                amountColor: AppColors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItemWidget extends StatelessWidget {
  final String title;
  final String amount;
  final Color amountColor;

  const NotificationItemWidget({
    super.key,
    required this.title,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 65.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x14000000), // figmadagi juda yengil shadow
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.semiBold20(
                const Color(0xff4A90F3),
              ).copyWith(
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            amount,
            style: AppStyle.semiBold20(amountColor).copyWith(
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}