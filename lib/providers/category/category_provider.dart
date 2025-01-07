import 'package:deltanews/data/api/api_service.dart';
import 'package:deltanews/data/models/get_category.dart';
import 'package:deltanews/data/models/category_model.dart';
import 'package:deltanews/utils/request_state.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final ApiService apiService;

  CategoryProvider({required this.apiService});

  RequestState _stateKategori = RequestState.initial;
  RequestState get stateKategori => _stateKategori;
  final List<Category> _kategoris = [];
  List<Category> get kategoris => _kategoris;
  String _messageKategori = '';
  String get messageKategori => _messageKategori;

  Future<void> getKategoris() async {
    _stateKategori = RequestState.loading;
    notifyListeners();
    try {
      final response = await apiService.getKategoris();
      if (response is GetCategory) {
        _kategoris.addAll(response.category!);
        _stateKategori = RequestState.loaded;
        notifyListeners();
        return;
      }
    } catch (e) {
      _stateKategori = RequestState.error;
      _messageKategori = e.toString();
      notifyListeners();
    }
  }

  // Fungsi untuk refresh konten
  Future<void> refreshContent() async {
    // Reset kategori
    _kategoris.clear();

    await getKategoris();
    notifyListeners();
  }
}
