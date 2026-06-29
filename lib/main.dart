import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shafmet/src/ui/splash/splash_screen.dart';
import 'package:shafmet/src/utilis/cache_service.dart';
import 'package:shafmet/src/utilis/token_refresh_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // SHU MUHIM
  await CacheService.init();
  TokenRefreshService.start();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          theme: ThemeData(
            platform: TargetPlatform.iOS,
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
