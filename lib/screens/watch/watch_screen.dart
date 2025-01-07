import 'package:deltanews/providers/watch/watch_provider.dart';
import 'package:deltanews/screens/watch/widgets/card_video.dart';
import 'package:deltanews/screens/widgets/custom_app_bar.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  @override
  void initState() {
    super.initState();

    final provider = context.read<WatchProvider>();
    Future.microtask(() => provider..getVideo(1));

    provider.scrollController.addListener(() {
      if (provider.scrollController.position.pixels >=
              provider.scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoadingMore) {
        provider.loadMoreRecentBeritas();
      }
    });
  }

  Future<void> _refreshData() async {
    final provider = context.read<WatchProvider>();
    await provider.resetPagination();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Stack(
        children: [
          Positioned(
            top: 0.h,
            left: 0.h,
            right: 0.h,
            child: const CustomAppBar(),
          ),
          Positioned(
            top: 80.h,
            left: 20.h,
            right: 20.h,
            child: Text(
              'Video',
              style: GoogleFonts.inter(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ),
          Positioned(
              left: 20.h,
              right: 20.h,
              top: 120.h,
              bottom: 60.h,
              child: Consumer<WatchProvider>(builder: (context, provider, _) {
                if (provider.state == RequestState.loading) {
                  return _buildShimmerLoading();
                } else if (provider.state == RequestState.loaded) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: provider.scrollController,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: provider.video.length +
                          (provider.isLoadingMore ? 1 : 0),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == provider.video.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: const Center(
                              child:
                                  CircularProgressIndicator(), // Loading indicator
                            ),
                          );
                        } else {
                          return CardVideo(
                            video: provider.video[index],
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: Text(provider.message),
                    ),
                  );
                }
              })),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 5, // Number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 250.h,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                Container(
                  height: 180.h,
                  width: double.infinity,
                  color: Colors.white,
                ),
                SizedBox(height: 5.h),
                Container(
                  height: 20.h,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
