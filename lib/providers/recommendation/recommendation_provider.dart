import 'package:deltanews/data/api/api_service.dart';
import 'package:deltanews/data/models/berita_model.dart';
import 'package:deltanews/data/models/get_berita.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:flutter/material.dart';

class RecommendationProvider extends ChangeNotifier {
  final ApiService apiService;

  RecommendationProvider({required this.apiService});

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

  Future<void> initState() async {
    _beritas = [];
    _currentPageRecent = 1;
    _hasMore = true;

    // _searchQuery = ''; // Reset pencarian jika kategori baru dipilih
    await getRecommendationBeritas(
        _currentPageRecent); // Panggil fungsi untuk load data
  }

  Future<void> getRecommendationBeritas(int page) async {
    if (!_hasMore) return; // Cek jika sudah tidak ada data lagi

    _state = RequestState.loading;
    notifyListeners();
    try {
      final GetBerita response =
          await apiService.getRecommendationBeritas(page);
      if (response.berita != null && response.berita!.isNotEmpty) {
        _beritas.addAll(response.berita!);
        _state = RequestState.loaded;
        _currentPageRecent = page;
        _hasMore =
            response.berita!.length >= 10; // Cek jika ada lebih dari 10 item
      } else {
        _hasMore = false; // Tidak ada lagi data yang bisa di-loa
      }
      notifyListeners();
    } catch (e) {
      _state = RequestState.error;
      _message = "Failed to fetch data: $e";
    }
    notifyListeners();
  }

  Future<void> loadMoreRecentBeritas() async {
    if (_state != RequestState.loading && _hasMore) {
      _isLoadingMore = true;
      notifyListeners();
      await getRecommendationBeritas(_currentPageRecent + 1);
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Fungsi untuk refresh konten
  Future<void> refreshContent() async {
    // Reset headline dan recent berita
    _beritas.clear();
    _currentPageRecent = 1;
    _hasMore = true;

    // Panggil ulang data headline dan berita terbaru
    await getRecommendationBeritas(1);
    notifyListeners();
  }
}
