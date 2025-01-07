import 'package:cached_network_image/cached_network_image.dart';
import 'package:deltanews/data/models/berita_model.dart';
import 'package:deltanews/screens/video_player_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CardVideo extends StatelessWidget {
  final Berita? video;

  const CardVideo({
    super.key,
    this.video,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Wrap the entire card in InkWell for ripple effect
      onTap: () {
        pushWithoutNavBar(
            context,
            CupertinoPageRoute(
              builder: (context) => VideoPlayerScreen(
                videoUrl: video!.postText!, // Pass the YouTube video URL
              ),
            ));
      },
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        height: 250.h,
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10.r), // Rounded corners for the image
              child: CachedNetworkImage(
                imageUrl: video?.image ??
                    'https://dummyimage.com/80x80/000/fff', // Default image if null
                height: 180.h,
                width: MediaQuery.of(context).size.width,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              video?.title ?? 'Error to load title',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
