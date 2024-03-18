import 'dart:convert';

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  int id;
  String name;
  String description;
  String icon;
  int parent;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.parent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"]??0,
        name: json["name"] !=null ?json["name"]:"",
        description: json["description"] !=null?json["description"]:"",
        icon: json["icon"] !=null?json["icon"]:"",
        parent: json["parent"] ?? 0,
        createdAt: json["created_at"] !=null?DateTime.parse(json["created_at"]):DateTime.now(),
        updatedAt: json["updated_at"] !=null?DateTime.parse(json["updated_at"]):DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "icon": icon,
        "parent":parent,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map["id"]??0,
      name: map["name"]??"",
      description: map["description"]??"",
      icon: map["icon"]??"",
      parent: map["parent"]??0,
      createdAt: map["created_at"]?DateTime.parse(map["created_at"]):DateTime.now(),
      updatedAt: map["updated_at"]?DateTime.parse(map["updated_at"]):DateTime.now(),
    );
  }
}
