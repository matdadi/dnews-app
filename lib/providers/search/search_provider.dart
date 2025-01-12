import 'package:deltanews/data/models/berita_model.dart';
import 'package:flutter/material.dart';
import 'package:deltanews/data/api/api_service.dart';
import 'package:deltanews/data/models/get_berita.dart';
import 'package:deltanews/utils/request_state.dart';

class SearchProvider with ChangeNotifier {
  final ApiService apiService;

  SearchProvider({required this.apiService}) {
    scrollController.addListener(_onScroll);
  }

  // State to track the search text
  String _searchText = '';
  String get searchText => _searchText;

  // State to store search results
  final List<Berita> _searchResults = [];
  List<Berita> get searchResults => _searchResults;

  // State to manage pagination
  int _currentPage = 1;
  bool _hasMore = true;
  String _message = '';
  RequestState _state = RequestState.initial;

  // Getters for accessing state and message
  RequestState get state => _state;
  bool get hasMore => _hasMore;
  String get message => _message;

  // Scroll controller for pagination handling
  final ScrollController scrollController = ScrollController();

  // Update the search text and reset the search state
  void updateSearchText(String newText) {
    _searchText = newText;
    _searchResults.clear();
    _currentPage = 1;
    _hasMore = true;
    _state = RequestState.initial;
    notifyListeners();
    search(_searchText); // Automatically initiate a search when text updates
  }

  // Perform a search using the ApiService with pagination support
  Future<void> search(String query, {bool isNewSearch = true}) async {
    if (_state == RequestState.loading || !_hasMore || query.isEmpty) return;

    if (isNewSearch) {
      // Clear existing results for a new search
      _searchResults.clear();
      _currentPage = 1;
      _hasMore = true;
      _state = RequestState.initial; // Reset state to initial for a new search
    }

    _state = RequestState.loading;
    _message = '';
    notifyListeners();

    try {
      // Replace with your API call using ApiService
      final GetBerita response =
          await apiService.searchBerita(_currentPage, query);

      if (response.berita != null && response.berita!.isNotEmpty) {
        _searchResults.addAll(response.berita!);
        _currentPage++;
        _hasMore = response.berita!.length >=
            10; // Check if there are more pages to load
        _state =
            RequestState.loaded; // Set state to loaded after successful fetch
      } else {
        _hasMore = false; // No more data available
        _state = RequestState.loaded; // Set state to loaded, but no more data
      }
    } catch (e) {
      _hasMore = false;
      _message = 'Failed to fetch data: $e';
      _state = RequestState.error; // Set state to error if an exception occurs
    }

    notifyListeners();
  }

  // Clear search text and reset the state
  void clearSearchText() {
    _searchText = '';
    _searchResults.clear();
    _currentPage = 1;
    _hasMore = true;
    _state = RequestState.noData;
    notifyListeners();
  }

  // Handle scroll events to trigger load more
  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        _hasMore &&
        _state != RequestState.loading) {
      search(_searchText);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
