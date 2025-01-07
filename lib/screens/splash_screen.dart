import 'package:deltanews/screens/main_screen.dart';
import 'package:deltanews/utils/animation_configuration.dart';
import 'package:deltanews/utils/permission_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    PermissionService().intialize();
    Future.delayed(const Duration(seconds: 2)).then((value) => nextScreen());
    super.initState();
  }

  void nextScreen() {
    Navigator.of(context).pushReplacement(CupertinoPageRoute(
      builder: (context) => const MainScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      color: Colors.white,
      child: Animate(
        effects: customItemZoomAppearanceEffects(
            delay: const Duration(milliseconds: 10),
            duration: const Duration(seconds: 1)),
        child: Center(
          // child: Text(
          //   'DNEWS',
          //   style: GoogleFonts.inter(
          //     color: primaryColor,
          //     fontSize: 64.sp,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          child: Image.asset(
            "assets/images/logo.png",
            height: 200.h,
          ),
        ),
      ),
    );
  }
}
