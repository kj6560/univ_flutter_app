import 'dart:convert';

List<Esports> esportsFromJson(String str) =>
    List<Esports>.from(json.decode(str).map((x) => Esports.fromJson(x)));

String esportsToJson(List<Esports> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class Esports {
  int id;
  String headerText;
  String images;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Esports({
    required this.id,
    required this.headerText,
    required this.images,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Esports.fromJson(Map<String, dynamic> json) =>
      Esports(
        id: json["id"],
        headerText: json['header_text']??"",
        images: json['images']??"",
        status: json['status']??0,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime(2017, 9, 7, 17, 30),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime(2017, 9, 7, 17, 30),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "header_text": headerText,
        "images": images,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String()
      };

  factory Esports.fromMap(Map<String, dynamic> map) {
    return Esports(
      id: map["id"],

      headerText: map['header_text'],
      images: map['images'],
      status: map['status'],
      createdAt: map["created_at"] != null
          ? DateTime.parse(map["created_at"])
          : DateTime(2017, 9, 7, 17, 30),
      updatedAt: map["updated_at"] != null
          ? DateTime.parse(map["updated_at"])
          : DateTime(2017, 9, 7, 17, 30),
    );
  }
}
