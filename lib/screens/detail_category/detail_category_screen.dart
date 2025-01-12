import 'package:deltanews/providers/detail_category/detail_category_provider.dart';
import 'package:deltanews/screens/home/widgets/card_news.dart';
import 'package:deltanews/screens/widgets/custom_app_bar.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:deltanews/utils/function_utils.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DetailCategoryScreen extends StatefulWidget {
  final String? category;
  final String? slugCategory;
  const DetailCategoryScreen(
      {super.key, required this.category, required this.slugCategory});
  @override
  State<DetailCategoryScreen> createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends State<DetailCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final provider = context.read<DetailCategoryProvider>();

    Future.microtask(() => provider..setCategory(widget.slugCategory ?? ''));

    provider.scrollController.addListener(() {
      if (provider.scrollController.position.pixels >=
              provider.scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoadingMore) {
        provider.loadMoreRecentBeritas();
      }
    });
  }

  Future<void> _refreshData() async {
    final provider = context.read<DetailCategoryProvider>();
    await provider.setCategory(widget.slugCategory ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(children: [
          Positioned(
            top: 0.h,
            left: 0.h,
            right: 0.h,
            child: const CustomAppBar(
              hasBackButton: true, // Ikon pencarian atau ikon 'X'
            ),
          ),
          Positioned(
            top: 72.h,
            left: 0.h,
            right: 0.h,
            child: Text(
              widget.category != ""
                  ? capitalizeEachWord(widget.category!)
                  : "Error to load category",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: primaryColor),
            ),
          ),
          Positioned(
              top: 100.h,
              bottom: 0.h,
              left: 0.h,
              right: 0.h,
              child: Consumer<DetailCategoryProvider>(
                  builder: (context, provider, _) {
                if (provider.state == RequestState.loading &&
                    provider.beritas.isEmpty) {
                  return _buildShimmerList();
                } else if (provider.state == RequestState.noData) {
                  return Center(
                    child: Text(
                      'Tidak ada data berita',
                      style: GoogleFonts.inter(
                          fontSize: 12.sp, color: primaryColor),
                    ),
                  );
                } else if (provider.state == RequestState.loaded ||
                    provider.state == RequestState.loading) {
                  return ListView.builder(
                    shrinkWrap: true,
                    controller: provider.scrollController,
                    padding:
                        EdgeInsets.only(left: 16.h, right: 16.h, bottom: 58.h),
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
                  return Center(
                    child: Text(provider.message),
                  );
                }
              }))
        ]),
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

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}
