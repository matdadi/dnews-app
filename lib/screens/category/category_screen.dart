import 'package:deltanews/providers/category/category_provider.dart';
import 'package:deltanews/providers/connectivity_provider.dart';
import 'package:deltanews/screens/category/widgets/category_button.dart';
import 'package:deltanews/screens/widgets/custom_app_bar.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<CategoryProvider>();
    Future.microtask(() => provider..getKategoris());
  }

  Future<void> _refreshContent() async {
    final provider = context.read<CategoryProvider>();
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
              left: 20.h,
              right: 20.h,
              child: Text(
                'Kategori',
                style: GoogleFonts.inter(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
              ),
            ),
            Consumer<CategoryProvider>(builder: (context, provider, _) {
              if (provider.stateKategori == RequestState.loading) {
                return Positioned(
                    left: 20.h,
                    right: 20.h,
                    top: 120.h,
                    child: _buildShimmerKategori());
              } else if (provider.stateKategori == RequestState.loaded) {
                return Positioned(
                  left: 20.h,
                  right: 20.h,
                  top: 120.h,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 220.h,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: provider.kategoris.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16.h,
                            mainAxisSpacing: 8.h),
                        itemBuilder: (context, index) =>
                            provider.kategoris[index].title != "Video"
                                ? CategoryButton(
                                    title: provider.kategoris[index].title!,
                                    slug: provider.kategoris[index].slug!,
                                    icon: provider.kategoris[index].icon)
                                : null,
                      ),
                    ),
                  ),
                );
              } else if (provider.stateKategori == RequestState.error) {
                return Positioned(
                  left: 20.h,
                  right: 20.h,
                  top: 120.h,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            provider.messageKategori,
                            style:
                                TextStyle(color: Colors.red, fontSize: 16.sp),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Tarik ke bawah untuk menyegarkan.',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            })
          ],
        ),
      );
    });
  }

  // Fungsi untuk membuat shimmer pada tombol kategori
  Widget _buildShimmerKategori() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 16.h, mainAxisSpacing: 8.h),
        itemCount: 6, // Jumlah shimmer dummy item yang ditampilkan
        itemBuilder: (context, index) => Container(
          width: 80.h,
          height: 80.h,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
      ),
    );
  }
}
