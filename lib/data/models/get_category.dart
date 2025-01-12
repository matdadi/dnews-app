// To parse this JSON data, do
//
//     final getCategory = getCategoryFromJson(jsonString);

import 'dart:convert';

import 'package:deltanews/data/models/category_model.dart';

GetCategory getCategoryFromJson(String str) =>
    GetCategory.fromJson(json.decode(str));

String getCategoryToJson(GetCategory data) => json.encode(data.toJson());

class GetCategory {
  int? code;
  String? message;
  List<Category>? category;

  GetCategory({
    this.code,
    this.message,
    this.category,
  });

  factory GetCategory.fromJson(Map<String, dynamic> json) => GetCategory(
        code: json["code"],
        message: json["message"],
        category: json["data"] == null
            ? []
            : List<Category>.from(
                json["data"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x.toJson())),
      };
}
