import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shafmet/src/app_theme/app_colors.dart';
import 'package:shafmet/src/app_theme/app_style.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<_CalendarDayModel> days = [
    _CalendarDayModel(day: 1, type: DayType.work),
    _CalendarDayModel(day: 2, type: DayType.work),
    _CalendarDayModel(day: 3, type: DayType.work),
    _CalendarDayModel(day: 4, type: DayType.work),
    _CalendarDayModel(day: 5, type: DayType.work),

    _CalendarDayModel(day: 6, type: DayType.work),
    _CalendarDayModel(day: 7, type: DayType.work),
    _CalendarDayModel(day: 8, type: DayType.work),
    _CalendarDayModel(day: 9, type: DayType.work),
    _CalendarDayModel(day: 10, type: DayType.off),

    _CalendarDayModel(day: 11, type: DayType.work),
    _CalendarDayModel(day: 12, type: DayType.work),
    _CalendarDayModel(day: 13, type: DayType.off),
    _CalendarDayModel(day: 14, type: DayType.work),
    _CalendarDayModel(day: 15, type: DayType.work),

    _CalendarDayModel(day: 16, type: DayType.work),
    _CalendarDayModel(day: 17, type: DayType.selected),
    _CalendarDayModel(day: 18, type: DayType.disabled),
    _CalendarDayModel(day: 19, type: DayType.disabled),
    _CalendarDayModel(day: 20, type: DayType.disabled),

    _CalendarDayModel(day: 21, type: DayType.disabled),
    _CalendarDayModel(day: 22, type: DayType.disabled),
    _CalendarDayModel(day: 23, type: DayType.disabled),
    _CalendarDayModel(day: 24, type: DayType.disabled),
    _CalendarDayModel(day: 25, type: DayType.disabled),

    _CalendarDayModel(day: 26, type: DayType.disabled),
    _CalendarDayModel(day: 27, type: DayType.disabled),
    _CalendarDayModel(day: 28, type: DayType.disabled),
    _CalendarDayModel(day: 29, type: DayType.disabled),
    _CalendarDayModel(day: 30, type: DayType.disabled),

    _CalendarDayModel(day: 31, type: DayType.disabled),
  ];

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
              /// Header
              SizedBox(height: 15.h,),
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
              SizedBox(height: 26.h),

              /// CALENDAR CONTAINER
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 22.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'iyyun',
                      style:AppStyle.regular14(AppColors.textGrey),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: AppStyle.medium16(AppColors.textColor).copyWith(
                              fontSize: 16.sp,
                            ),
                            children: [
                              const TextSpan(text: 'ish kuni : '),
                              TextSpan(
                                text: '15 kun',
                                style: AppStyle.semiBold20(
                                  const Color(0xff4A90F3),
                                ).copyWith(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        RichText(
                          text: TextSpan(
                            style: AppStyle.medium16(AppColors.textColor).copyWith(
                              fontSize: 16.sp,
                            ),
                            children: [
                              const TextSpan(text: 'dam: '),
                              TextSpan(
                                text: '2 kun',
                                style: AppStyle.semiBold20(
                                  const Color(0xffFF4D4F),
                                ).copyWith(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),

                    /// days grid
                    GridView.builder(
                      itemCount: days.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final item = days[index];
                        return _buildDayItem(item);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayItem(_CalendarDayModel item) {
    Color bgColor;
    Color textColor;
    BorderRadius borderRadius = BorderRadius.circular(12.r);

    switch (item.type) {
      case DayType.work:
        bgColor = const Color(0xffEAF2FF);
        textColor = const Color(0xff4A90F3);
        break;

      case DayType.off:
        bgColor = const Color(0xffFFECEC);
        textColor = const Color(0xffFF4D4F);
        break;

      case DayType.selected:
        bgColor = const Color(0xff4A90F3);
        textColor = Colors.white;
        break;

      case DayType.disabled:
        bgColor = Colors.transparent;
        textColor = const Color(0xffD0D0D0);
        break;
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
      ),
      child: Text(
        item.day.toString(),
        style: AppStyle.semiBold20(textColor).copyWith(
          fontSize: 16.sp,
        ),
      ),
    );
  }
}

enum DayType {
  work,
  off,
  selected,
  disabled,
}

class _CalendarDayModel {
  final int day;
  final DayType type;

  _CalendarDayModel({
    required this.day,
    required this.type,
  });
}