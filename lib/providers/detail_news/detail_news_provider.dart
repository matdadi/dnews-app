import 'package:deltanews/data/api/api_service.dart';
import 'package:deltanews/data/models/berita_model.dart';
import 'package:deltanews/data/models/get_detail.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:flutter/material.dart';

class DetailNewsProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailNewsProvider({required this.apiService});

  Berita? _detailBerita = Berita();
  String _message = '';
  RequestState _state = RequestState.initial;

  // Getters for accessing state and message
  RequestState get state => _state;
  Berita? get berita => _detailBerita;
  String get message => _message;

  // New method to clear data
  void clearData() {
    _detailBerita = Berita();
    _state = RequestState.initial;
    _message = '';
  }

  Future<void> getDetailBerita(String id) async {
    _state = RequestState.loading;
    notifyListeners();
    try {
      final response = await apiService.detailBerita(id);
      if (response is GetDetailBerita) {
        _detailBerita = response.berita!;
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

  Future<void> refreshContent(String id) async {
    _state = RequestState.loading;
    // Reset headline dan recent berita
    _detailBerita = Berita();
    notifyListeners();

    // Panggil ulang data headline dan berita terbaru
    await getDetailBerita(id);
  }
}
