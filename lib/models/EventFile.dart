// To parse this JSON data, do
//
//     final eventFile = eventFileFromJson(jsonString);

import 'dart:convert';

List<EventFile> eventFileFromJson(String str) =>
    List<EventFile>.from(json.decode(str).map((x) => EventFile.fromJson(x)));

String eventFileToJson(List<EventFile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventFile {
  int id;
  int eventId;
  String image;
  int imagePriority;
  String eventVideo;
  dynamic videoPriority;
  DateTime createdAt;
  DateTime updatedAt;

  EventFile({
    required this.id,
    required this.eventId,
    required this.image,
    required this.imagePriority,
    required this.eventVideo,
    required this.videoPriority,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventFile.fromJson(Map<String, dynamic> json) => EventFile(
        id: json["id"],
        eventId: json["event_id"],
        image: json["image"],
        imagePriority: json["image_priority"],
        eventVideo: json["event_video"] ?? "",
        videoPriority: json["video_priority"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "image": image,
        "image_priority": imagePriority,
        "event_video": eventVideo,
        "video_priority": videoPriority,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  factory EventFile.fromMap(Map<String, dynamic> map) {
    return EventFile(
      id: map["id"],
      eventId: map["event_id"],
      image: map["image"],
      imagePriority: map["image_priority"],
      eventVideo: map["event_video"],
      videoPriority: map["video_priority"],
      createdAt: DateTime.parse(map["created_at"]),
      updatedAt: DateTime.parse(map["updated_at"]),
    );
  }
}
