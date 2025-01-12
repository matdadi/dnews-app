// To parse this JSON data, do
//
//     final detailBeritaResponse = detailBeritaResponseFromJson(jsonString);

import 'dart:convert';

import 'package:deltanews/data/models/berita_model.dart';

GetDetailBerita detailBeritaResponseFromJson(String str) =>
    GetDetailBerita.fromJson(json.decode(str));

String detailBeritaResponseToJson(GetDetailBerita data) =>
    json.encode(data.toJson());

class GetDetailBerita {
  int? code;
  String? message;
  Berita? berita;

  GetDetailBerita({
    this.code,
    this.message,
    this.berita,
  });

  factory GetDetailBerita.fromJson(Map<String, dynamic> json) =>
      GetDetailBerita(
        code: json["code"],
        message: json["message"],
        berita: json["data"] == null ? null : Berita.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": berita?.toJson(),
      };
}
