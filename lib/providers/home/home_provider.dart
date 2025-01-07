import 'package:deltanews/data/api/api_service.dart';
import 'package:deltanews/data/models/berita_model.dart';
import 'package:deltanews/data/models/get_berita.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService apiService;

  HomeProvider({required this.apiService});

  final PageController _pageController = PageController();
  int _currentPage = 0;

  PageController get pageController => _pageController;
  int get currentPage => _currentPage;

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Pagination variables
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  int _currentPageRecent = 1;
  final ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  String _selectedCategory = 'Terbaru';
  String get selectedCategory => _selectedCategory;

  // Fungsi untuk mengatur kategori dan reset data
  void setCategory(String category) {
    _selectedCategory = category;

    // Reset data recent beritas dan pagination
    _recentBeritas = [];
    _currentPageRecent = 1;
    _hasMore = true;

    getRecentBeritas(1); // Muat data baru sesuai kategori yang dipilih
    notifyListeners();
  }

  RequestState _stateHeadlineBerita = RequestState.initial;
  RequestState get stateHeadlineBerita => _stateHeadlineBerita;
  final List<Berita> _headlineBeritas = [];
  List<Berita> get headlineBeritas => _headlineBeritas;
  String _messageHeadlineBerita = '';
  String get messageHeadlineBerita => _messageHeadlineBerita;

  Future<void> getHeadlineBeritas() async {
    _stateHeadlineBerita = RequestState.loading;
    notifyListeners();
    try {
      final response = await apiService.getHeadlineBeritas();
      if (response is GetBerita) {
        _headlineBeritas.addAll(response.berita!);
        _stateHeadlineBerita = RequestState.loaded;
        notifyListeners();
        return;
      }
    } catch (e) {
      _stateHeadlineBerita = RequestState.error;
      _messageHeadlineBerita = e.toString();
      notifyListeners();
    }
  }

  RequestState _stateRecentBerita = RequestState.initial;
  RequestState get stateRecentBerita => _stateRecentBerita;
  List<Berita> _recentBeritas = [];
  List<Berita> get recentBeritas => _recentBeritas;
  String _messageRecentBerita = '';
  String get messageRecentBerita => _messageRecentBerita;

  Future<void> getRecentBeritas(int page) async {
    if (!_hasMore) return; // Cek jika sudah tidak ada data lagi

    _stateRecentBerita = RequestState.loading;
    notifyListeners();
    try {
      GetBerita response = GetBerita();

      // Tentukan API yang dipanggil berdasarkan kategori yang dipilih
      if (_selectedCategory == 'Terbaru') {
        response = await apiService.getRecentBeritas(page); // API Terbaru
      } else if (_selectedCategory == 'Terpopuler') {
        response = await apiService.getPopularBeritas(page); // API Terpopuler
      } else if (_selectedCategory == 'Featured Article') {
        response = await apiService.getLifestyleBeritas(page); // API Lifestyle
      }

      if (response.berita != null && response.berita!.isNotEmpty) {
        _recentBeritas.addAll(response.berita!);
        _stateRecentBerita = RequestState.loaded;
        _currentPageRecent = page;
        _hasMore =
            response.berita!.length >= 10; // Cek jika ada lebih dari 10 item
      } else {
        _hasMore = false; // Tidak ada lagi data yang bisa di-load
      }

      notifyListeners();
    } catch (e) {
      _stateRecentBerita = RequestState.error;
      _messageRecentBerita = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadMoreRecentBeritas() async {
    if (_stateRecentBerita != RequestState.loading && _hasMore) {
      _isLoadingMore = true;
      notifyListeners();
      await getRecentBeritas(_currentPageRecent + 1);
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Fungsi untuk refresh konten
  Future<void> refreshContent() async {
    // Reset headline dan recent berita
    _headlineBeritas.clear();
    _recentBeritas.clear();
    _currentPageRecent = 1;
    _hasMore = true;

    // Panggil ulang data headline dan berita terbaru
    await getHeadlineBeritas();
    await getRecentBeritas(1);
    notifyListeners();
  }
}
