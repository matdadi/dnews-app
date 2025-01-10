import 'dart:convert';
import 'package:deltanews/data/models/get_berita.dart';
import 'package:deltanews/data/models/get_category.dart';
import 'package:deltanews/data/models/get_detail.dart';
import 'package:deltanews/data/models/register_param.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = 'http://103.245.39.17/api/v1/';
  static const String baseUrl =
      'https://orange-chamois-936801.hostingersite.com/public/api/v1/';

  static const String authUrl =
      'https://dnewsindonesia.com/wp-json/jwt-auth/v1/token';
  static const int timeOut = 10000;

  final client = http.Client();

  final _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> getBeritasByCategory(int page, String category) async {
    const String endpoint = 'post';
    final url =
        Uri.parse('$baseUrl$endpoint?limit=10&page=$page&category=$category');
    final response = await client
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: timeOut));
    if (response.statusCode == 200) {
      return GetBerita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Mendapatkan Berita');
    }
  }

  Future<dynamic> getBeritasByTag(int page, String tag) async {
    const String endpoint = 'post';
    final url = Uri.parse('$baseUrl$endpoint?limit=10&page=$page&tag=$tag');
    final response = await client
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: timeOut));
    if (response.statusCode == 200) {
      return GetBerita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Mendapatkan Berita');
    }
  }

  Future<dynamic> getHeadlineBeritas() async {
    const String endpoint = 'headline';
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await client
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: timeOut));
    if (response.statusCode == 200) {
      return GetBerita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Mendapatkan Headline Berita');
    }
  }

  Future<dynamic> getRecentBeritas(int page) async {
    const String endpoint = 'recent-post';
    final url = Uri.parse('$baseUrl$endpoint?limit=10&page=$page');
    final response = await client
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: timeOut));
    // log(
    //   "recent ${response.body}",
    // );
    if (response.statusCode == 200) {
      return GetBerita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Mendapatkan Berita Terbaru');
    }
  }

  Future<dynamic> getPopularBeritas(int page) async {
    const String endpoint = 'popular-post';
    final url = Uri.parse('$baseUrl$endpoint?limit=10&page=$page');
    final response = await client
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: timeOut));
    if (response.statusCode == 200) {
      return GetBerita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Mendapatkan Berita Terpopuler');
    }
  }

  Future<dynamic> getLifestyleBeritas(int page) async {
    const String endpoint = 'featured-article-post';
    final url = Uri.parse('$baseUrl$endpoint?limit=10&page=$page');
    final response = await client
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: timeOut));
    if (response.statusCode == 200) {
      return GetBerita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Mendapatkan Featured Article');
    }
  }

  Future<dynamic> getRecommendationBeritas(int page) async {
    const String endpoint = 'recommendation';
    final url = Uri.parse('$baseUrl$endpoint?limit=10&page=$page');
    final response = await client
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: timeOut));
    if (response.statusCode == 200) {
      return GetBerita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Mendapatkan Berita Rekomendasi');
    }
  }

  Future<dynamic> getVideo(int page) async {
    const String endpoint = 'video';
    final url = Uri.parse('$baseUrl$endpoint?limit=10&page=$page');
    final response = await client
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: timeOut));
    if (response.statusCode == 200) {
      return GetBerita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Mendapatkan Berita Rekomendasi');
    }
  }

  Future<dynamic> searchBerita(int page, String search) async {
    const String endpoint = 'post';
    final url =
        Uri.parse('$baseUrl$endpoint?limit=10&page=$page&search=$search');
    final response = await client
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: timeOut));
    if (response.statusCode == 200) {
      return GetBerita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Mendapatkan Berita');
    }
  }

  Future<dynamic> detailBerita(String id) async {
    const String endpoint = 'post';
    final url = Uri.parse('$baseUrl$endpoint/$id');
    final response = await client
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: timeOut));
    if (response.statusCode == 200) {
      return GetDetailBerita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Mendapatkan Detail Berita');
    }
  }

  Future<dynamic> getKategoris() async {
    const String endpoint = 'category';
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await client
        .get(url, headers: _headers)
        .timeout(const Duration(seconds: timeOut));
    if (response.statusCode == 200) {
      return GetCategory.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Mendapatkan Kategori');
    }
  }

  Future<dynamic> login(String email, String password) async {
    const String endpoint = 'token';
    final url = Uri.parse('$authUrl$endpoint');
    try {
      final response = await client
          .post(url,
              headers: _headers,
              body: jsonEncode({'username': email, 'password': password}))
          .timeout(const Duration(seconds: timeOut));
      if ([200, 401, 400, 404, 403, 500].contains(response.statusCode)) {
        final result =
            jsonEncode({'code': response.statusCode, 'body': response.body});
        return result;
      }
      throw Exception('Gagal Login');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> register(RegisterParam param) async {
    const String endpoint =
        'https://dnewsindonesia.com/register';
    final url = Uri.parse(endpoint);
    final body = param.toQueryParams()
      ..removeWhere((key, value) => value == null);
    try {
      final response = await client
          .post(url, headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: timeOut));
      if ([200, 401, 400, 404, 403, 500].contains(response.statusCode)) {
        final result =
            jsonEncode({'code': response.statusCode, 'body': response.body});
        return result;
      }
      throw Exception('Gagal Login');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
