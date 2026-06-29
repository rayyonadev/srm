import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shafmet/src/ui/splash/main/calendar/calendar_screen.dart';
import 'package:shafmet/src/ui/splash/main/home/home_screen.dart';
import 'package:shafmet/src/ui/splash/main/notification/notification_screen.dart';
import 'package:shafmet/src/ui/splash/main/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const CalendarScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  final List<String> navIcons = [
    'assets/icons/home.svg',
    'assets/icons/calendar.svg',
    'assets/icons/message.svg',
    'assets/icons/profile.svg',
  ];

  final List<String> navLabels = [
    'Asosiy',
    'Ish kunlari',
    'Bildirishnoma',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      body: Stack(
        children: [
           Positioned.fill(
            child: IndexedStack(
              index: selectedIndex,
              children: screens,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h, left: 12.w, right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 17.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(navIcons.length, (index) {
                  final isSelected = selectedIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xffEEF6FF)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              navIcons[index],
                              width: isSelected ? 22.w : 20.w,
                              height: isSelected ? 22.w : 20.w,
                              colorFilter: ColorFilter.mode(
                                isSelected
                                    ? const Color(0xff63A9FF)
                                    : const Color(0xff8D99AE),
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              navLabels[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isSelected
                                    ? const Color(0xff63A9FF)
                                    : const Color(0xff8D99AE),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}