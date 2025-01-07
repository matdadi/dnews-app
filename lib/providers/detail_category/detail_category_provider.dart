import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:deltanews/data/api/api_service.dart';
import 'package:deltanews/data/models/berita_model.dart';
import 'package:deltanews/data/models/get_berita.dart';
import 'package:deltanews/utils/request_state.dart';

class DetailCategoryProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailCategoryProvider({required this.apiService});

  // State untuk melacak kategori yang dipilih
  String _category = '';
  String get category => _category;

  // // Fungsi untuk mengatur kategori dan memuat data sesuai kategori
  Future<void> setCategory(String category) async {
    _category = category;
    _beritas = [];
    _currentPageRecent = 1;
    _hasMore = true;

    // _searchQuery = ''; // Reset pencarian jika kategori baru dipilih
    await _getBeritasByCategory(
        _currentPageRecent); // Panggil fungsi untuk load data
  }

  // // State untuk melacak data berita
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

  // Fetch berita berdasarkan kategori
  Future<void> _getBeritasByCategory(int page) async {
    if (!_hasMore) return; // Cek jika sudah tidak ada data lagi

    _state = RequestState.loading;
    notifyListeners();
    try {
      final GetBerita response =
          await apiService.getBeritasByCategory(page, _category);
      if (response.berita != null && response.berita!.isNotEmpty) {
        _beritas.addAll(response.berita!);
        _state = RequestState.loaded;
        _currentPageRecent = page;
        _hasMore =
            response.berita!.length >= 10; // Cek jika ada lebih dari 10 item
      } else {
        log('no more data');
        if (response.berita!.isEmpty && _beritas.isEmpty) {
          _state = RequestState.noData;
        }
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
      await _getBeritasByCategory(_currentPageRecent + 1);
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
