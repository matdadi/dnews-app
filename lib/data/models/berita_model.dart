import 'package:deltanews/data/models/category_model.dart';

class Berita {
  int? id;
  String? title;
  String? author;
  String? slug;
  Category? category;
  Category? subcategory;
  List<Category>? tags;
  String? postText;
  int? postViews;
  String? image;
  String? status;
  bool? isHeadline;
  DateTime? createdAt;
  DateTime? updatedAt;

  Berita({
    this.id,
    this.title,
    this.author,
    this.slug,
    this.category,
    this.subcategory,
    this.tags,
    this.postText,
    this.postViews,
    this.image,
    this.status,
    this.isHeadline,
    this.createdAt,
    this.updatedAt,
  });

  factory Berita.fromJson(Map<String, dynamic> json) => Berita(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        slug: json["slug"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        subcategory: json["subcategory"] == null
            ? null
            : Category.fromJson(json["subcategory"]),
        tags: json["tags"] == null
            ? []
            : List<Category>.from(
                json["tags"]!.map((x) => Category.fromJson(x))),
        postText: json["post_text"],
        postViews: json["post_views"],
        image: json["image"],
        status: json["status"],
        isHeadline: json["is_headline"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "slug": slug,
        "category": category?.toJson(),
        "subcategory": subcategory?.toJson(),
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "post_text": postText,
        "post_views": postViews,
        "image": image,
        "status": status,
        "is_headline": isHeadline,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
