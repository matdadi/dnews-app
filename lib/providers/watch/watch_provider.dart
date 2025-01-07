import 'package:deltanews/data/api/api_service.dart';
import 'package:deltanews/data/models/berita_model.dart';
import 'package:deltanews/data/models/get_berita.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:flutter/material.dart';

class WatchProvider extends ChangeNotifier {
  final ApiService apiService;

  WatchProvider({required this.apiService});

  final List<Berita> _video = [];
  List<Berita> get video => _video;

  String _message = '';
  String get message => _message;

  RequestState _state = RequestState.initial;
  RequestState get state => _state;

  // Pagination variables
  bool _hasMoreData = true;
  bool get hasMore => _hasMoreData;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  Future<void> getVideo(int page) async {
    if (!_hasMoreData) return; // Do not fetch if there's no more data
    _state = RequestState.loading;
    notifyListeners();

    try {
      final response = await apiService.getVideo(page);
      if (response is GetBerita) {
        if (response.berita != null && response.berita!.isNotEmpty) {
          _video.addAll(response.berita!);
          _currentPage = page; // Increment the page
          _hasMoreData =
              response.berita!.length >= 10; // Cek jika ada lebih dari 10 item
        } else {
          _hasMoreData = false; // No more data available
        }
        _state = RequestState.loaded;
      } else {
        _state = RequestState.error;
      }
    } catch (e) {
      _state = RequestState.error;
      _message = 'Failed to fetch data: $e';
    }

    notifyListeners();
  }

  // Method to reset pagination
  Future<void> resetPagination() async {
    _video.clear();
    _currentPage = 1;
    _hasMoreData = true;
    await getVideo(_currentPage);
    notifyListeners();
  }

  Future<void> loadMoreRecentBeritas() async {
    if (_state != RequestState.loading && _hasMoreData) {
      _isLoadingMore = true;
      notifyListeners();
      await getVideo(_currentPage + 1);
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
