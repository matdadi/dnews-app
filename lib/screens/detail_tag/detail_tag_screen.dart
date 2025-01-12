import 'package:deltanews/providers/detail_tag/detail_tag_provider.dart';
import 'package:deltanews/screens/home/widgets/card_news.dart';
import 'package:deltanews/screens/widgets/custom_app_bar.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:deltanews/utils/function_utils.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DetailTagScreen extends StatefulWidget {
  final String? category;
  final String? slugCategory;
  const DetailTagScreen(
      {super.key, required this.category, required this.slugCategory});
  @override
  State<DetailTagScreen> createState() => _DetailTagScreenState();
}

class _DetailTagScreenState extends State<DetailTagScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final provider = context.read<DetailTagProvider>();

    Future.microtask(() => provider..setTag(widget.slugCategory ?? ''));
  }

  Future<void> _refreshData() async {
    final provider = context.read<DetailTagProvider>();
    await provider.setTag(widget.slugCategory ?? '');
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
            child: CustomAppBar(
              hasBackButton: true,
              icon: Icons.search, // Ikon pencarian atau ikon 'X'
              onIconPressed: () {},
            ),
          ),
          Consumer<DetailTagProvider>(
            builder: (context, provider, child) {
              return Positioned(
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
              );
            },
          ),
          Consumer<DetailTagProvider>(
            builder: (context, provider, child) {
              return Positioned(
                  top: 100.h, // Menyesuaikan top saat pencarian
                  bottom: 0.h,
                  left: 0.h,
                  right: 0.h,
                  child: provider.state == RequestState.loading &&
                          provider.beritas.isEmpty
                      ? _buildShimmerList()
                      : provider.state == RequestState.loaded ||
                              provider.state == RequestState.loading
                          ? SingleChildScrollView(
                              controller: provider.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 16.h),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: provider.beritas.length +
                                    (provider.isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == provider.beritas.length) {
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
                                      berita: provider.beritas[index],
                                      hasNavbar: false,
                                    );
                                  }
                                },
                              ),
                            )
                          : SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(provider.message),
                              ),
                            ));
            },
          ),
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
