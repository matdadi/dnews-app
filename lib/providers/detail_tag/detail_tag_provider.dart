import 'package:flutter/material.dart';
import 'package:deltanews/data/api/api_service.dart';
import 'package:deltanews/data/models/berita_model.dart';
import 'package:deltanews/data/models/get_berita.dart';
import 'package:deltanews/utils/request_state.dart';

class DetailTagProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailTagProvider({required this.apiService}) {
    _scrollController.addListener(_onScroll);
  }

  // State to track the selected tag
  String _tag = '';
  String get tag => _tag;

  // Set tag and fetch data based on the selected tag
  Future<void> setTag(String tag) async {
    _tag = tag;
    _beritas = [];
    _currentPageRecent = 1;
    _hasMore = true;
    await _getBeritasByTag(_currentPageRecent); // Load data for the new tag
  }

  // State to track the loading state of the provider
  RequestState _state = RequestState.initial;
  RequestState get state => _state;

  List<Berita> _beritas = [];
  List<Berita> get beritas => _beritas;

  String _message = '';
  String get message => _message;

  // Pagination variables
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  int _currentPageRecent = 1;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  // Fetch berita based on the selected tag and page number
  Future<void> _getBeritasByTag(int page) async {
    if (!_hasMore) return; // Check if more data is available

    _state = RequestState.loading;
    notifyListeners();

    try {
      final GetBerita response = await apiService.getBeritasByTag(page, _tag);
      if (response.berita != null && response.berita!.isNotEmpty) {
        _beritas.addAll(response.berita!);
        _state = RequestState.loaded;
        _currentPageRecent = page;
        _hasMore = response.berita!.length >=
            10; // Assume more data if 10+ items are returned
      } else {
        _hasMore = false; // No more data to load
      }
    } catch (e) {
      _state = RequestState.error;
      _message = "Failed to fetch data: $e";
    }

    notifyListeners();
  }

  // Load more recent berita when the user scrolls down
  Future<void> loadMoreRecentBeritas() async {
    if (_state != RequestState.loading && _hasMore) {
      _isLoadingMore = true;
      notifyListeners();
      await _getBeritasByTag(_currentPageRecent + 1);
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Handle scroll events for pagination
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      loadMoreRecentBeritas();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
