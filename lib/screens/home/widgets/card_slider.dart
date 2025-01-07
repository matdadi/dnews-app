import 'package:cached_network_image/cached_network_image.dart';
import 'package:deltanews/data/models/berita_model.dart';
import 'package:deltanews/screens/detail_news/detail_news_screen.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:deltanews/utils/function_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CardSlider extends StatelessWidget {
  final Berita berita;
  const CardSlider({
    super.key,
    required this.berita,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340.h,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        onTap: () {
          pushWithNavBar(
              context,
              CupertinoPageRoute(
                builder: (context) => DetailNewsScreen(
                  id: berita.id.toString(),
                ),
              ));
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.r),
                  topLeft: Radius.circular(10.r)),
              child:
                  // Image.asset(
                  //   fit: BoxFit.cover,
                  //   height: 235.h,
                  //   'assets/images/dummy_slider.png',
                  //   color: Colors.white.withOpacity(0.9),
                  //   colorBlendMode: BlendMode.modulate,
                  // )),
                  CachedNetworkImage(
                imageUrl: berita.image ??
                    'https://dummyimage.com/600x400/000/fff', // URL gambar
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                height: 235.h,
                width: double.infinity,
              ),
            ),
            Container(
              height: 105.h,
              padding: EdgeInsets.all(10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    berita.title ?? 'Error to load title',
                    softWrap: true,
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: '${berita.author} - '),
                    TextSpan(text: getTime(berita.createdAt.toString()))
                  ])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
