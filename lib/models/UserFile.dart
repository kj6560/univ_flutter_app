import 'dart:convert';

List<UserFile> userFileFromJson(String str) => List<UserFile>.from(json.decode(str).map((x) => UserFile.fromJson(x)));

String userFileToJson(List<UserFile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserFile {
  int id;
  int userId;
  int fileType;
  String filePath;
  String? title;
  String? description;
  String? tags;
  DateTime createdAt;
  DateTime updatedAt;

  UserFile({
    required this.id,
    required this.userId,
    required this.fileType,
    required this.filePath,
    required this.title,
    required this.description,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserFile.fromJson(Map<String, dynamic> json) => UserFile(
    id: json["id"],
    userId: json["user_id"],
    fileType: json["file_type"],
    filePath: json["file_path"],
    title: json["title"],
    description: json["description"],
    tags: json["tags"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "file_type": fileType,
    "file_path": filePath,
    "title": title,
    "description": description,
    "tags": tags,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
