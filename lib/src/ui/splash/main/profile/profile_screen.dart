import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shafmet/src/app_theme/app_colors.dart';
import '../../../../app_theme/app_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              SizedBox(height: 20.h),

              /// ISHCHI KARTASI
              _IshchiCard(
                avatarAsset: 'assets/images/group.png',
                ism: 'Javohir Hamroyev',
                lavozim: "Ichki do'kon ishchisi",
                faollikFoiz: 0.60,
              ),
              SizedBox(height: 20.h),
              /// BALANS KARTASI
              _BalansCard(
                balans: '25 450',
                ism: 'Hamroyev Javohir',
              ),
              SizedBox(height: 28.h,),
              Text("Tarix",style: AppStyle.bold16(AppColors.textColor),),
              SizedBox(height: 12.h,),
              NotificationItemWidget(
                title: 'kunlik topshriq bajarildi',
                amount: '+2 000 so`m',
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
                title: 'kunlik topshriq bajarildi',
                amount: '+2 000 so`m',
                amountColor: AppColors.green,
              ),
              SizedBox(height: 14.h),
              NotificationItemWidget(
                title: 'kunlik topshriq bajarildi',
                amount: '+2 000 so`m',
                amountColor: AppColors.green,
              ),
              SizedBox(height: 55.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// ISHCHI KARTASI WIDGET
class _IshchiCard extends StatelessWidget {
  final String avatarAsset;
  final String ism;
  final String lavozim;
  final double faollikFoiz; // 0.0 dan 1.0 gacha

  const _IshchiCard({
    required this.avatarAsset,
    required this.ism,
    required this.lavozim,
    required this.faollikFoiz,
  });

  @override
  Widget build(BuildContext context) {
    final int foizInt = (faollikFoiz * 100).round();

    return Container(
      width: double.infinity,
      height: 143.h,
      decoration: BoxDecoration(
        color: const Color(0xFF4A95FE),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Yuqori qism: avatar + ism + lavozim
          Row(
            children: [
              /// Avatar rasm
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    avatarAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          ism.isNotEmpty ? ism[0] : 'J',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(width: 14.w),

              /// Ism va lavozim
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ism,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      lavozim,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// Quyi qism: faollik + progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kun mobaynida faollik',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$foizInt%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              /// Progress bar
              Container(
                width: double.infinity,
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: faollikFoiz,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE234),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// BALANS KARTASI WIDGET
class _BalansCard extends StatelessWidget {
  final String balans;
  final String ism;

  const _BalansCard({
    required this.balans,
    required this.ism,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 175.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A95FE), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -100.w,
            top: -55.h,
            child: Image.asset(
              "assets/images/shafmet.png",
              width: 300.w,
              height: 300.w,
              color: Colors.white,
              fit: BoxFit.contain,
            ),
          ),

          /// Asosiy kontent
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balans',
                  style:AppStyle.semiBold20(AppColors.blue)
                ),
                SizedBox(height: 7.h,),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$balans ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: "so'm",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  ism,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15.h,),
              ],
            ),
          ),

        ],
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