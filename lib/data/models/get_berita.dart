import 'dart:convert';

import 'package:deltanews/data/models/berita_model.dart';

GetBerita getBeritaFromJson(String str) => GetBerita.fromJson(json.decode(str));

String getBeritaToJson(GetBerita data) => json.encode(data.toJson());

class GetBerita {
  int? code;
  String? message;
  List<Berita>? berita;

  GetBerita({
    this.code,
    this.message,
    this.berita,
  });

  factory GetBerita.fromJson(Map<String, dynamic> json) => GetBerita(
        code: json["code"],
        message: json["message"],
        berita: json["data"] == null
            ? []
            : List<Berita>.from(json["data"]!.map((x) => Berita.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": berita == null
            ? []
            : List<dynamic>.from(berita!.map((x) => x.toJson())),
      };
}
