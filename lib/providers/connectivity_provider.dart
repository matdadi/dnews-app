import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    _checkConnectivity(); // Cek koneksi saat provider diinisialisasi
    _subscribeToConnectivityChanges(); // Dengarkan perubahan koneksi
  }

  // Cek status koneksi saat provider dimulai
  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _isConnected = _hasConnection(connectivityResult);
    notifyListeners();
  }

  // Berlangganan untuk mendengarkan perubahan koneksi
  void _subscribeToConnectivityChanges() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> resultList) {
      _isConnected =
          _hasConnection(resultList); // Cek apakah ada koneksi di dalam list
      notifyListeners(); // Update UI ketika koneksi berubah
    });
  }

  // Fungsi untuk mengecek apakah koneksi ada di dalam List<ConnectivityResult>
  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi);
  }

  // Fungsi untuk menampilkan dialog koneksi hilang
  void showNoConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tidak Ada Koneksi Internet"),
          content: const Text(
              "Anda sedang tidak terhubung ke internet. Periksa koneksi Anda dan coba lagi."),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop(); // Menutup dialog
                // Menggunakan exit(0) untuk menutup aplikasi secara langsung
                if (Platform.isAndroid || Platform.isIOS) {
                  exit(0); // Tutup aplikasi untuk platform Android/iOS
                } else {
                  SystemNavigator.pop(); // Tutup aplikasi untuk platform lain
                }
              },
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }
}
