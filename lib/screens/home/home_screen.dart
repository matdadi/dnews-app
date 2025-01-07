import 'package:deltanews/providers/connectivity_provider.dart';
import 'package:deltanews/providers/home/home_provider.dart';
import 'package:deltanews/screens/home/widgets/card_news.dart';
import 'package:deltanews/screens/home/widgets/card_slider.dart';
import 'package:deltanews/screens/home/widgets/kategori_button.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:deltanews/screens/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<HomeProvider>();

    Future.microtask(() => provider
      ..getHeadlineBeritas()
      ..getRecentBeritas(1));

    provider.scrollController.addListener(() {
      if (provider.scrollController.position.pixels >=
              provider.scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoadingMore) {
        provider.loadMoreRecentBeritas();
      }
    });
  }

  Future<void> _refreshContent() async {
    final provider = context.read<HomeProvider>();
    await provider.refreshContent();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, provider, _) {
      // Menggunakan addPostFrameCallback agar dialog ditampilkan setelah build selesai
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!provider.isConnected) {
          provider
              .showNoConnectionDialog(context); // Panggil dialog dari provider
        }
      });
      return RefreshIndicator(
        onRefresh: _refreshContent,
        child: Stack(
          children: [
            Positioned(
                top: 0.h, left: 0.h, right: 0.h, child: const CustomAppBar()),
            Positioned(
              top: 80.h,
              left: 0.h,
              right: 0.h,
              child: Consumer<HomeProvider>(
                builder: (context, provider, _) {
                  if (provider.stateHeadlineBerita == RequestState.loading) {
                    return _buildShimmerKategoriButtons(); // Tambahkan shimmer untuk kategori button
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          KategoriButton(
                            title: 'Terbaru',
                            isActive: provider.selectedCategory == 'Terbaru',
                          ),
                          SizedBox(width: 10.h),
                          KategoriButton(
                            title: 'Terpopuler',
                            isActive: provider.selectedCategory == 'Terpopuler',
                          ),
                          SizedBox(width: 10.h),
                          KategoriButton(
                            title: 'Featured Article',
                            isActive:
                                provider.selectedCategory == 'Featured Article',
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Positioned(
              top: 140.h,
              left: 0.h,
              right: 0.h,
              bottom: 60.h,
              child: Consumer<HomeProvider>(builder: (context, provider, _) {
                return SingleChildScrollView(
                  controller: provider.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      if (provider.selectedCategory != "Featured Article")
                        SizedBox(
                          height: 360.h,
                          child: Consumer<HomeProvider>(
                              builder: (context, provider, _) {
                            if (provider.stateHeadlineBerita ==
                                RequestState.loading) {
                              return _buildShimmerSlider();
                            } else if (provider.stateHeadlineBerita ==
                                RequestState.loaded) {
                              if (provider.headlineBeritas.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Tidak Ada Headline Berita',
                                    style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              } else {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: PageView.builder(
                                        controller: provider
                                            .pageController, // Controller dari Provider
                                        itemCount:
                                            provider.headlineBeritas.length,
                                        onPageChanged: (int page) {
                                          provider.onPageChanged(
                                              page); // Update page di provider
                                        },
                                        itemBuilder: (context, index) {
                                          return CardSlider(
                                              berita: provider
                                                  .headlineBeritas[index]);
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    SmoothPageIndicator(
                                      controller: provider.pageController,
                                      count: provider.headlineBeritas.length,
                                      effect: ExpandingDotsEffect(
                                        activeDotColor: primaryColor,
                                        dotHeight: 8.h,
                                        dotWidth: 8.h,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            } else {
                              return Center(
                                child: Text(provider.messageHeadlineBerita),
                              );
                            }
                          }),
                        ),
                      Consumer<HomeProvider>(builder: (context, provider, _) {
                        if (provider.stateRecentBerita ==
                                RequestState.loading &&
                            provider.recentBeritas.isEmpty) {
                          return _buildShimmerList();
                        } else if (provider.stateRecentBerita ==
                                RequestState.loaded ||
                            provider.stateRecentBerita ==
                                RequestState.loading) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 20.h, right: 20.h, top: 8.h),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.recentBeritas.length +
                                  (provider.isLoadingMore
                                      ? 1
                                      : 0), // Tambahkan 1 jika sedang loading
                              itemBuilder: (context, index) {
                                if (index == provider.recentBeritas.length) {
                                  // Tampilkan loading di item terakhir
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: const Center(
                                      child:
                                          CircularProgressIndicator(), // Loading indicator
                                    ),
                                  );
                                } else {
                                  return CardNews(
                                    berita: provider.recentBeritas[index],
                                  );
                                }
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(provider.messageRecentBerita),
                          );
                        }
                      })
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  // Fungsi untuk membuat shimmer pada tombol kategori
  Widget _buildShimmerKategoriButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.h),
            width: 80.h,
            height: 30.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15.r),
            ),
          ),
        );
      }),
    );
  }

  // Fungsi untuk membuat efek shimmer pada slider
  Widget _buildShimmerSlider() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 360.h,
        margin: EdgeInsets.symmetric(horizontal: 8.h),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  // Fungsi untuk membuat efek shimmer pada daftar berita
  Widget _buildShimmerList() {
    return Padding(
      padding: EdgeInsets.only(left: 20.h, right: 20.h, top: 8.h),
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
