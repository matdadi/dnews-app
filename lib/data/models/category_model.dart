class Category {
  int? id;
  String? icon;
  String? name;
  String? title;
  String? slug;
  List<Category>? subcategory;

  Category({
    this.id,
    this.icon,
    this.name,
    this.title,
    this.slug,
    this.subcategory,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        icon: json["icon"],
        name: json["name"],
        title: json["title"],
        slug: json["slug"],
        subcategory: json["subcategory"] == null
            ? []
            : List<Category>.from(
                json["subcategory"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "name": name,
        "title": title,
        "slug": slug,
        "subcategory": subcategory == null
            ? []
            : List<dynamic>.from(subcategory!.map((x) => x.toJson())),
      };
}
