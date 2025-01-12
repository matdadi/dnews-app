import 'package:cached_network_image/cached_network_image.dart';
import 'package:deltanews/data/models/berita_model.dart';
import 'package:deltanews/screens/detail_news/detail_news_screen.dart';
// import 'package:deltanews/utils/colors.dart';
import 'package:deltanews/utils/function_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CardNews extends StatefulWidget {
  final Berita? berita;
  final bool hasNavbar;
  const CardNews({super.key, this.berita, this.hasNavbar = true});

  @override
  State<CardNews> createState() => _CardNewsState();
}

class _CardNewsState extends State<CardNews> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      width: MediaQuery.of(context).size.width,
      height: 100.h,
      child: InkWell(
        onTap: () {
          pushWithNavBar(
              context,
              CupertinoPageRoute(
                builder: (context) => DetailNewsScreen(
                  id: widget.berita?.id.toString(),
                  hasNavbar: widget.hasNavbar,
                ),
              ));
        },
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/images/dummy_berita.png',
            //   height: 80.h,
            //   width: 80.h,
            // ),
            CachedNetworkImage(
              imageUrl: widget.berita?.image ??
                  'https://dummyimage.com/80x80/000/fff', // URL gambar default jika imageUrl null
              height: 80.h,
              width: 80.h,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 10.h,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              height: 100.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.berita?.title ?? 'Error to load title',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: GoogleFonts.inter(
                        fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  // Text(
                  //   widget.berita?.author ?? 'Error to load author',
                  //   softWrap: true,
                  //   style: GoogleFonts.inter(fontSize: 10.sp),
                  // ),
                  RichText(
                      text: TextSpan(
                          style: GoogleFonts.inter(
                              fontSize: 8.sp, color: Colors.black),
                          children: [
                        TextSpan(
                            text: widget.berita?.author != null
                                ? '${widget.berita?.author} - '
                                : 'error to load author'),
                        TextSpan(
                            text: widget.berita?.createdAt != null
                                ? getTime(widget.berita!.createdAt!.toString())
                                : 'error to load time')
                      ])),
                ],
              ),
            ),
            // const Spacer(),
            // IconButton(
            //   icon: const Icon(Icons.bookmark_outline),
            //   onPressed: () {},
            //   color: primaryColor,
            // )
          ],
        ),
      ),
    );
  }
}
