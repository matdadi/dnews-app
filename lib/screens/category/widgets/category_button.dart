import 'package:cached_network_image/cached_network_image.dart';
import 'package:deltanews/screens/detail_category/detail_category_screen.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final String slug;
  final String? icon;
  const CategoryButton({
    super.key,
    required this.title,
    required this.slug,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 64.h,
      width: 64.h,
      child: InkWell(
        onTap: () {
          pushWithNavBar(
              context,
              CupertinoPageRoute(
                builder: (context) => DetailCategoryScreen(
                  category: title,
                  slugCategory: slug,
                ),
              ));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40.h,
              width: 40.h,
              decoration: icon == null
                  ? const BoxDecoration(
                      shape: BoxShape.circle, color: thirdColor)
                  : null,
              child: Center(
                child: icon == null
                    ? Icon(
                        Icons.heart_broken_outlined,
                        color: softRed,
                        size: 32.h,
                      )
                    : CachedNetworkImage(
                        imageUrl: icon!,
                        height: 32.h,
                        width: 32.h,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(fontSize: 10.sp),
            )
          ],
        ),
      ),
    );
  }
}
