import 'package:deltanews/providers/recommendation/recommendation_provider.dart';
import 'package:deltanews/screens/home/widgets/card_news.dart';
import 'package:deltanews/screens/widgets/custom_app_bar.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  @override
  void initState() {
    super.initState();

    final provider = context.read<RecommendationProvider>();

    Future.microtask(() => provider..initState());

    provider.scrollController.addListener(() {
      if (provider.scrollController.position.pixels >=
              provider.scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoadingMore) {
        provider.loadMoreRecentBeritas();
      }
    });
  }

  Future<void> _refreshContent() async {
    final provider = context.read<RecommendationProvider>();
    await provider.refreshContent();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshContent,
      child: Stack(
        children: [
          Positioned(
              top: 0.h, left: 0.h, right: 0.h, child: const CustomAppBar()),
          Positioned(
            left: 20.h,
            right: 20.h,
            top: 80.h,
            bottom: 60.h,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller:
                  context.read<RecommendationProvider>().scrollController,
              child: Column(
                children: [
                  Text(
                    'Rekomendasi Untuk Anda',
                    style: GoogleFonts.inter(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp),
                  ),
                  Consumer<RecommendationProvider>(
                      builder: (context, provider, _) {
                    if (provider.state == RequestState.loading &&
                        provider.beritas.isEmpty) {
                      return _buildShimmerList();
                    } else if (provider.state == RequestState.loaded ||
                        provider.state == RequestState.loading) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.beritas.length +
                            (provider.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == provider.beritas.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: const Center(
                                child:
                                    CircularProgressIndicator(), // Loading indicator
                              ),
                            );
                          } else {
                            return CardNews(
                              berita: provider.beritas[index],
                            );
                          }
                        },
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Center(
                          child: Text(provider.message),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Fungsi untuk membuat efek shimmer pada daftar berita
  Widget _buildShimmerList() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        children: List.generate(
          5, // Jumlah item shimmer
          (index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              height: 100.h,
              color: Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }
}
