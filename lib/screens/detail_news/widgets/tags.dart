import 'package:deltanews/screens/detail_tag/detail_tag_screen.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Tags extends StatelessWidget {
  final String? title;
  final String? slug;
  const Tags({
    super.key,
    this.title,
    this.slug,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        pushWithoutNavBar(
            context,
            CupertinoPageRoute(
              builder: (context) => DetailTagScreen(
                category: title,
                slugCategory: slug,
              ),
            ));
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(8.h),
        backgroundColor: grey,
      ),
      child: Text(
        title ?? 'error to load tag',
        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 10.sp),
      ),
    );
  }
}
