import 'package:cached_network_image/cached_network_image.dart';
import 'package:deltanews/providers/detail_news/detail_news_provider.dart';
import 'package:deltanews/screens/detail_news/widgets/tags.dart';
import 'package:deltanews/screens/full_image/full_image_screen.dart';
import 'package:deltanews/screens/widgets/custom_app_bar.dart';
import 'package:deltanews/utils/function_utils.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DetailNewsScreen extends StatefulWidget {
  final String? id;
  final bool hasNavbar;
  const DetailNewsScreen({super.key, required this.id, this.hasNavbar = true});

  @override
  State<DetailNewsScreen> createState() => _DetailNewsScreenState();
}

class _DetailNewsScreenState extends State<DetailNewsScreen> {
  @override
  void initState() {
    super.initState();

    final provider = context.read<DetailNewsProvider>();
    provider.clearData();
    Future.microtask(() => provider..getDetailBerita(widget.id!));
  }

  Future<void> _refreshContent() async {
    final provider = context.read<DetailNewsProvider>();
    provider.clearData();
    await provider.refreshContent(widget.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshContent,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  top: 0.h,
                  left: 0.h,
                  right: 0.h,
                  child: CustomAppBar(
                    hasBackButton: widget.hasNavbar,
                  ),
                ),
                Positioned(
                  left: 20.h,
                  right: 20.h,
                  top: 80.h,
                  bottom: widget.hasNavbar ? 60.h : 16.h,
                  child: Consumer<DetailNewsProvider>(
                      builder: (context, provider, _) {
                    if (provider.state == RequestState.loading) {
                      return _buildShimmerLoading();
                    } else if (provider.state == RequestState.error) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.h),
                            child: Text(
                              provider.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              provider.berita?.title ?? 'Error to load title',
                              style: GoogleFonts.inter(
                                fontSize: 24.h,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                                color: Colors.black, // memastikan teks hitam
                              ),
                            ),
                            SizedBox(height: 10.h),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: Colors.black, // memastikan teks hitam
                                ),
                                children: [
                                  TextSpan(
                                    text: provider.berita?.author != null
                                        ? '${provider.berita?.author} - '
                                        : 'error to load author',
                                  ),
                                  TextSpan(
                                    text: provider.berita?.createdAt != null
                                        ? getTime(provider.berita!.createdAt!
                                            .toString())
                                        : 'error to load time',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Material(
                              color: Colors
                                  .transparent, // background tetap transparan
                              borderRadius: BorderRadius.circular(10.r),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  pushWithoutNavBar(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => FullImageScreen(
                                        imageUrl: provider.berita?.image ??
                                            'https://via.placeholder.com/500x300',
                                      ),
                                    ),
                                  );
                                },
                                splashColor: Colors.blue.withValues(alpha: 0.3),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        provider.berita?.image ??
                                            'https://via.placeholder.com/500x300',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 200,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            HtmlWidget(
                              provider.berita?.postText ??
                                  '<p>Error to load post text</p>',
                              customStylesBuilder: (element) {
                                // Memastikan warna teks dalam HTML tetap hitam
                                if (element.localName == 'p' ||
                                    element.localName == 'span') {
                                  return {'color': 'black'};
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children:
                                  provider.berita?.tags?.isNotEmpty == true
                                      ? provider.berita!.tags!
                                          .map((tag) => Tags(
                                                title: tag.name,
                                                slug: tag.slug,
                                              ))
                                          .toList()
                                      : [const SizedBox.shrink()],
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 24.h,
              width: double.infinity,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10.h),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 12.h,
              width: 150.w,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 5.h),
            ),
          ),
          SizedBox(height: 10.h),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 200.h,
              width: double.infinity,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10.h),
            ),
          ),
          SizedBox(height: 10.h),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 100.h,
              width: double.infinity,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10.h),
            ),
          ),
          SizedBox(height: 20.h),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: List.generate(3, (index) {
                return Container(
                  height: 30.h,
                  width: 80.w,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
