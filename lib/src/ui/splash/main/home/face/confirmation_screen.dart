import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shafmet/src/api/repository.dart';
import 'package:shafmet/src/app_theme/app_colors.dart';
import 'package:shafmet/src/dialog/toast_notification.dart';
import 'package:video_player/video_player.dart';
import '../../../../../app_theme/app_style.dart';
import '../../../../../utilis/cache_service.dart';
import 'confirmation_start_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  final String photoPath;

  const ConfirmationScreen({
    super.key,
    required this.photoPath,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  int progress = 1;
  Timer? _timer;
  late VideoPlayerController _videoController;

  bool _apiCompleted = false;
  bool _apiSuccess = false;
  String _errorMessage = '';

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    _startCounter();
    _startCheckIn();

    _videoController = VideoPlayerController.asset(
      'assets/images/395e0a10b14070c666525dda380f8238.gif.mp4',
    )..initialize().then((_) {
        _videoController.setLooping(true);
        _videoController.play();
        setState(() {});
      });
  }

  Future<void> _startCheckIn() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          Position? lastPosition = await Geolocator.getLastKnownPosition();
          if (lastPosition != null) {
            latitude = lastPosition.latitude;
            longitude = lastPosition.longitude;
          }

          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 3),
          );
          latitude = position.latitude;
          longitude = position.longitude;
          debugPrint("Location fetched in ConfirmationScreen: LAT: $latitude, LON: $longitude");
        }
      }
    } catch (e) {
      debugPrint("Error fetching location in ConfirmationScreen: $e");
    }

    try {
      debugPrint("Sending photo to backend check-in: ${widget.photoPath}");

      final result = await repository.checkInMultipart(
        photoPath: widget.photoPath,
        latitude: latitude,
        longitude: longitude,
      );

      if (!mounted) return;

      if (result.isSuccess) {
        // Save today's date in SharedPreferences
        final String todayStr = DateTime.now().toString().split(' ').first;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('last_check_in_date', todayStr);

        setState(() {
          _apiCompleted = true;
          _apiSuccess = true;
        });
      } else {
        String errorMsg = result.result.toString();
        try {
          final decoded = jsonDecode(errorMsg);
          if (decoded is Map) {
            errorMsg = decoded['message'] ?? decoded['detail'] ?? decoded['error'] ?? errorMsg;
          }
        } catch (_) {}
        
        setState(() {
          _apiCompleted = true;
          _apiSuccess = false;
          _errorMessage = errorMsg;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _apiCompleted = true;
        _apiSuccess = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _startCounter() {
    const totalDuration = 5;
    const maxValue = 100;

    _timer = Timer.periodic(
      Duration(milliseconds: (totalDuration * 1000) ~/ maxValue),
      (timer) {
        if (progress >= maxValue) {
          if (_apiCompleted) {
            timer.cancel();
            if (!mounted) return;

            if (_apiSuccess) {
              AppToast.success(
                context: context,
                description: "Muvaffaqiyatli tekshirildi",
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConfirmationStartScreen(),
                ),
              );
            } else {
              AppToast.error(
                context: context,
                description: "Xatolik yuz berdi: $_errorMessage",
              );
              Navigator.pop(context);
            }
          } else {
            setState(() {
              progress = 100;
            });
          }
        } else {
          setState(() {
            progress++;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Ortga" tugmasi
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.only(top: 87.h, left: 24.w),
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
                        vertical: 7.h, horizontal: 11.w),
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

          SizedBox(height: 120.h),

          // Sarlavha: Yuzni va manzil Tasdiqlash
          Center(
            child: Text(
              "Yuzni va manzil Tasdiqlash",
              style: AppStyle.bold24(AppColors.textColor),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 8.h),

          // Foiz ko'rsatkichi matni
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Malumot va manzil anqlanmoqda",
                style: AppStyle.semiBold14(AppColors.textColor),
              ),
              SizedBox(width: 6.w),
              Text(
                "$progress%",
                style: AppStyle.semiBold14(AppColors.blueBg),
              ),
            ],
          ),

          SizedBox(height: 60.h),

          // MP4 Animatsiyani ko'rsatuvchi qism
          Center(
            child: _videoController.value.isInitialized
                ? SizedBox(
                    width: 250.w,
                    height: 250.h,
                    child: VideoPlayer(_videoController),
                  )
                : const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}