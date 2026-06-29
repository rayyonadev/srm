import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shafmet/src/api/repository.dart';
import 'package:shafmet/src/app_theme/app_colors.dart';
import 'package:shafmet/src/app_theme/app_style.dart';
import 'package:shafmet/src/bloc/home/home_bloc.dart';
import 'package:shafmet/src/bloc/home/home_event.dart';
import 'package:shafmet/src/bloc/home/home_state.dart';
import 'package:shafmet/src/ui/splash/main/home/face/face_id_screen.dart';
import 'package:shafmet/src/ui/splash/main/home/face/face_recorder.dart';
import 'package:shafmet/src/utilis/cache_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String getFormattedDate() {
    final now = DateTime.now();
    final weekdays = ['yak', 'dush', 'sesh', 'chor', 'pay', 'juma', 'shan'];
    final months = [
      'yanvar', 'fevral', 'mart', 'aprel', 'may', 'iyun',
      'iyul', 'avgust', 'sentabr', 'oktabr', 'noyabr', 'dekabr'
    ];

    final weekday = weekdays[now.weekday % 7];
    final day = now.day;
    final month = months[now.month - 1];

    return '$weekday-$day-$month';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(CacheService.getToken());
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(repository: repository)..add(FetchProfileEvent()),
      child: Scaffold(
        backgroundColor: AppColors.whiteBg,
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blueBg,
                  ),
                );
              }

              if (state is HomeErrorState) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded, size: 48.sp, color: AppColors.red),
                        SizedBox(height: 16.h),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: AppStyle.medium16(AppColors.textColor),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<HomeBloc>().add(FetchProfileEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blueBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            "Qayta urinish",
                            style: AppStyle.bold16(AppColors.white).copyWith(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is HomeSuccessState) {
                final profile = state.profile;
                final String firstName = profile.firstName;
                final String lastName = profile.lastName;
                final String fullName = '$firstName $lastName'.trim().isNotEmpty
                    ? '$firstName $lastName'.trim()
                    : 'Javohir Hamroyev';
                final String displaySalomName = firstName.isNotEmpty ? firstName.toLowerCase() : 'javohir';
                final String role = profile.role ?? "ichki do'kon ishchisi";

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('salom', style: AppStyle.medium16(AppColors.textGrey)),
                                    Text(displaySalomName, style: AppStyle.semiBold20(AppColors.textColor).copyWith(fontSize: 20.sp)),
                                  ],
                                ),
                                Container(
                                  width: 72.w,
                                  height: 67.w,
                                  child: Image.asset(
                                    "assets/images/shafmet.png",
                                    fit: BoxFit.cover,
                                    color: AppColors.blueBg,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 35.h),
                            // PROFILE CARD
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (builder) => const FaceRecorder()));
                              },
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: AppColors.blueBg,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          child: CircleAvatar(
                                            radius: 50,
                                            child: Image.asset(
                                              "assets/images/group.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(fullName, style: AppStyle.bold16(AppColors.white).copyWith(fontSize: 15.sp)),
                                              Text(role, style: AppStyle.regular14(AppColors.white.withOpacity(0.75))),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.chevron_right, color: Colors.white, size: 24.sp),
                                      ],
                                    ),
                                    SizedBox(height: 14.h),
                                    Divider(color: Colors.white.withOpacity(0.25), height: 1),
                                    SizedBox(height: 12.h),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/calendar.svg",
                                          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                                          height: 16,
                                          width: 16,
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(getFormattedDate(), style: AppStyle.regular12(Colors.white.withOpacity(0.85))),
                                        SizedBox(width: 20.w),
                                        Icon(Icons.access_time_outlined, color: Colors.white.withOpacity(0.85), size: 16.sp),
                                        SizedBox(width: 5.w),
                                        Text(state.isCheckedInToday ? "ish boshlandi" : "face id dan o'tish", style: AppStyle.regular12(Colors.white.withOpacity(0.85))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 35.h),
                            Text('Topshiriqlar', style: AppStyle.bold16(AppColors.textColor)),

                            SizedBox(height: 16.h),
                            _TaskCard(
                              icon: Icons.cleaning_services_outlined,
                              title: 'Tozalikga Rioya hudud',
                              subtitle: 'hududiy tozalik',
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (builder) {
                                  return const FaceIdScreen();
                                }));
                              },
                            ),

                            SizedBox(height: 12.h),

                            _TaskCard(
                              icon: Icons.inventory_2_outlined,
                              title: 'Mahsulot Joylab Chqish',
                              subtitle: 'Polka Toldrsh',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      height: 64.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _navItem(Icons.home_rounded, 'asosiy', true),
                          _navItem(Icons.calendar_month_outlined, '', false),
                          _navItem(Icons.chat_bubble_outline, '', false),
                          _navItem(Icons.person_outline, '', false),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    final color = isActive ? AppColors.blue : AppColors.textGrey;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24.sp, color: color),
        if (label.isNotEmpty) ...[
          SizedBox(height: 3.h),
          Text(label, style: AppStyle.regular12(color).copyWith(fontSize: 10.sp)),
        ],
      ],
    );
  }
}
class _TaskCard extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final String title;
  final String subtitle;

  const _TaskCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A2E),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppStyle.bold16(AppColors.textColor).copyWith(fontSize: 14.sp)),
                    SizedBox(height: 3.h),
                    Text(subtitle, style: AppStyle.regular14(AppColors.textGrey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(color: const Color(0xFFF1F1F1), height: 1),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.access_time_outlined, size: 13.sp, color: AppColors.orange),
                SizedBox(width: 4.w),
                Text('1 soatlik hisabot', style: AppStyle.regular12(AppColors.orange).copyWith(fontSize: 11.sp)),
                SizedBox(width: 16.w),
                Icon(Icons.access_time_outlined, size: 13.sp, color: AppColors.blueBg),
                SizedBox(width: 4.w),
                Text('tugash vaqti 15:00', style: AppStyle.regular12(AppColors.blueBg).copyWith(fontSize: 11.sp)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}