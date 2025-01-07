import 'dart:async';

import 'package:deltanews/providers/search/search_provider.dart';
import 'package:deltanews/screens/home/widgets/card_news.dart';
import 'package:deltanews/screens/widgets/custom_app_bar.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // void _onSearchTextChanged() {
  //   if (_debounce?.isActive ?? false) _debounce?.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     final query = _searchController.text.trim();
  //     context.read<SearchProvider>().updateSearchText(query);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().clearSearchText();
    });
  }

  Future<void> _performSearch(String query) async {
    final searchProvider = context.read<SearchProvider>();
    await searchProvider.search(query, isNewSearch: true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.read<SearchProvider>().clearSearchText();
        return; // Allow the back navigation
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
              top: 0.h,
              left: 0.h,
              right: 0.h,
              child: const CustomAppBar(
                hasBackButton: true,
                hasSearch: false,
              ),
            ),
            Positioned(
              top: 72.h,
              left: 0.h,
              right: 0.h,
              child: ValueListenableBuilder(
                  valueListenable: _searchController,
                  builder: (context, TextEditingValue value, _) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: TextFormField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: "Search...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: value.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.text = '';
                                    context
                                        .read<SearchProvider>()
                                        .clearSearchText();
                                  },
                                )
                              : null,
                        ),
                        onFieldSubmitted: (text) {
                          if (text.isNotEmpty) {
                            _performSearch(text);
                          }
                        },
                      ),
                    );
                  }),
            ),
            Positioned(
              top: 130.h,
              bottom: 0.h,
              left: 0.h,
              right: 0.h,
              child: Consumer<SearchProvider>(
                builder: (context, searchProvider, _) {
                  if (searchProvider.state == RequestState.loading) {
                    return _buildShimmerList();
                  } else if (searchProvider.state == RequestState.error) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Text(
                          searchProvider.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  } else if (searchProvider.searchResults.isNotEmpty) {
                    return ListView.builder(
                      controller: searchProvider.scrollController,
                      padding: EdgeInsets.all(16.h),
                      itemCount: searchProvider.searchResults.length +
                          (searchProvider.state == RequestState.loading
                              ? 1
                              : 0),
                      itemBuilder: (context, index) {
                        if (index < searchProvider.searchResults.length) {
                          return CardNews(
                            berita: searchProvider.searchResults[index],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16.h),
                        child: Center(
                          child: Text(
                            'No results found',
                            textAlign: TextAlign.justify,
                            style:
                                TextStyle(fontSize: 16.sp, color: primaryColor),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build shimmer effect for loading
  Widget _buildShimmerList() {
    return Padding(
      padding: EdgeInsets.only(left: 20.h, right: 20.h, top: 8.h),
      child: Column(
        children: List.generate(
          5,
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
    _searchController.dispose();
    super.dispose();
  }
}
