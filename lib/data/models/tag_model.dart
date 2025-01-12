class Tag {
  int? id;
  String? name;
  String? slug;

  Tag({
    this.id,
    this.name,
    this.slug,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
      };
}
