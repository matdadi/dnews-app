import 'package:deltanews/core/assets/assets.gen.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialogBoxWithButton extends StatelessWidget {
  final String title, description, confirmTextButton;
  final bool isError;
  // final Image img;
  final Function()? onPressed;
  final Function() onCancelPressed;

  const CustomDialogBoxWithButton(
      {super.key,
      required this.title,
      required this.description,
      required this.confirmTextButton,
      required this.onPressed,
      this.onCancelPressed = _defaultOnCancelPressed,
      this.isError = false});

  static void _defaultOnCancelPressed() {
    // Tidak melakukan apa-apa
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 16.h),
      margin: EdgeInsets.only(top: 48.w),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black,
                offset: const Offset(0, 10),
                blurRadius: 10.h),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.images.logo.path,
            height: 80.h,
          ),
          SizedBox(
            height: 24.h,
          ),
          Text(
            title,
            style: GoogleFonts.inter(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: isError ? Colors.redAccent : primaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            description,
            style: GoogleFonts.inter(fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.h,
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.r)))),
            child: Text(
              confirmTextButton,
              style: GoogleFonts.inter(fontSize: 12.sp),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
