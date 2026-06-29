import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shafmet/src/api/repository.dart';
import 'package:shafmet/src/app_theme/app_colors.dart';
import 'package:shafmet/src/app_theme/app_style.dart';
import 'package:shafmet/src/dialog/toast_notification.dart';
import 'package:shafmet/src/ui/splash/main/main_screen.dart';
import 'package:shafmet/src/utilis/cache_service.dart';

import '../../../model/http_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          const _LoginBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 119.h),
                  Center(
                    child: Text(
                      'Kirish',
                      style: AppStyle.bold30(AppColors.blueBg),
                    ),
                  ),
                  SizedBox(height: 19.h),
                  Center(
                    child: Text(
                      'Assalomu alaykum Tizimga\nKirish Pastda',
                      textAlign: TextAlign.center,
                      style: AppStyle.semiBold20(
                        AppColors.textColor,
                      ).copyWith(height: 1.6),
                    ),
                  ),
                  SizedBox(height: 59.h),
                  _LoginTextField(
                    controller: phoneController,
                    hintText: 'Telefon Raqam',
                    isActive: false,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 29.h),
                  _LoginTextField(
                    controller: passwordController,
                    hintText: 'Parolingiz',
                    isActive: false,
                    obscureText: true,
                  ),

                  SizedBox(height: 30.h),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Parolingiz esdan chiqdimi?',
                      style: AppStyle.semiBold14(AppColors.blueBg),
                    ),
                  ),

                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    height: 60.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        String formatPhone(String phone) {
                          String cleaned = phone.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          );

                          if (cleaned.startsWith('998')) {
                            return '+$cleaned';
                          }

                          if (cleaned.length == 9) {
                            return '+998$cleaned';
                          }

                          if (cleaned.length == 12 &&
                              !cleaned.startsWith('998')) {
                            return '+$cleaned';
                          }

                          return '+998$cleaned';
                        }

                        try {
                          final result = await repository.login({
                            "phone": formatPhone(phoneController.text.trim()),
                            "password": passwordController.text.trim(),
                          });

                          print('phone: ${formatPhone(phoneController.text.trim())}');
                          print('isSuccess: ${result.isSuccess}');
                          print('statusCode: ${result.statusCode}');
                          print('result: ${result.result}');

                          if (result.isSuccess && result.statusCode == 200) {
                            Map<String, dynamic> data = {};

                            if (result.result is String) {
                              data = jsonDecode(result.result);
                            } else if (result.result is Map) {
                              data = Map<String, dynamic>.from(result.result);
                            }

                            final String accessToken = data['access'] ?? '';
                            final String refreshToken = data['refresh'] ?? '';

                            // Cache tokens first
                            await CacheService.saveToken(accessToken);
                            await CacheService.saveRefreshToken(refreshToken);
                            
                            // Write directly to SharedPreferences keys read by ApiProvider
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('access', accessToken);
                            await prefs.setString('refresh', refreshToken);

                            // Optional: Cache user info if present in login response
                            if (data['user'] != null) {
                              final user = Map<String, dynamic>.from(data['user']);
                              final String fullName = user['full_name'] ?? '';
                              final List<String> parts = fullName.split(' ');
                              String firstName = '';
                              String lastName = '';
                              if (parts.isNotEmpty) {
                                firstName = parts.last;
                                if (parts.length > 1) {
                                  lastName = parts.first;
                                }
                              }
                              CacheService.saveUserFirstName(firstName);
                              CacheService.saveUserLastName(lastName);
                              if (user['role'] != null) {
                                await CacheService.saveUserRole(user['role']);
                              }
                            }

                            if (mounted) {
                              AppToast.success(
                                context: context,
                                description: 'Tizimga kirdingiz',
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const MainScreen()),
                                    (route) => false,
                              );
                            }


                          } else {
                            String errorMessage = 'Login xatoligi';
                            Map<String, dynamic> data = {};

                            if (result.result is String) {
                              data = jsonDecode(result.result);
                            } else if (result.result is Map) {
                              data = Map<String, dynamic>.from(result.result);
                            }

                            if (data['non_field_errors'] != null &&
                                data['non_field_errors'] is List &&
                                data['non_field_errors'].isNotEmpty) {
                              errorMessage = data['non_field_errors'][0].toString();
                            } else if (data['message'] != null) {
                              errorMessage = data['message'].toString();
                            } else if (data['detail'] != null) {
                              errorMessage = data['detail'].toString();
                            }

                            AppToast.error(
                              context: context,
                              description: errorMessage,
                            );
                          }
                        } catch (e) {
                          print('LOGIN ERROR: $e');

                          AppToast.error(
                            context: context,
                            description: 'Kutilmagan xatolik yuz berdi',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueBg,
                        elevation: 8,
                        shadowColor: AppColors.blue.withOpacity(0.30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'Kirish',
                        style: AppStyle.semiBold20(AppColors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Center(
                    child: Text(
                      'Akkaunt yaratish',
                      style: AppStyle.semiBold14(AppColors.textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isActive;
  final bool obscureText;
  final TextInputType keyboardType;

  const _LoginTextField({
    required this.controller,
    required this.hintText,
    this.isActive = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<_LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<_LoginTextField> {
  late FocusNode _focusNode;
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _obscure = widget.obscureText;

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool active = _focusNode.hasFocus;

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: active ? AppColors.blue : Colors.transparent,
          width: 1.4.w,
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              obscureText: _obscure,
              keyboardType: widget.keyboardType,
              style: AppStyle.medium16(AppColors.textColor),
              inputFormatters: widget.keyboardType == TextInputType.phone
                  ? [
                      PhoneInputFormatter(
                        defaultCountryCode: 'UZ',
                        allowEndlessPhone: false,
                      ),
                    ]
                  : null,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 17.h,
                ),
                hintText: widget.hintText,
                hintStyle: AppStyle.regular14(AppColors.textGrey),
              ),
            ),
          ),
          if (widget.obscureText)
            IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textGrey,
                size: 20.sp,
              ),
              onPressed: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
            ),
        ],
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Chap yuqori — kichik ochiq kulrang aylana
        Positioned(
          top: -220.h,
          right: -160.w,
          child: Container(
            width: 500.w,
            height: 500.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEFF4FF), width: 2.w),
            ),
          ),
        ),

        // O'ng yuqori — katta ochiq kulrang aylana (ko'k EMAS)
        Positioned(
          top: -180.h,
          right: -180.w,
          child: Container(
            width: 440.w,
            height: 440.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greyBg,
            ),
          ),
        ),

        // Past qismdagi chiziqli naqishlar
        Positioned.fill(
          child: IgnorePointer(child: CustomPaint(painter: _LoginBgPainter())),
        ),
      ],
    );
  }
}

class _LoginBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEAF1FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Chap tomondagi qisqa gorizontal chiziq
    canvas.drawLine(
      Offset(0, size.height * 0.67),
      Offset(size.width * 0.12, size.height * 0.67),
      paint,
    );

    // Tik chiziq pastga
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.75),
      Offset(size.width * 0.18, size.height),
      paint,
    );

    // Siniq shakl (broken polygon)
    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.82)
      ..lineTo(size.width * 0.44, size.height * 0.82)
      ..lineTo(size.width * 0.58, size.height * 0.90)
      ..lineTo(size.width * 0.40, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
