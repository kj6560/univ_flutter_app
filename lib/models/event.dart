import 'dart:convert';

List<Event> eventFromJson(String str) =>
    List<Event>.from(json.decode(str).map((x) => Event.fromJson(x)));

String eventToJson(List<Event> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Event {
  int id;
  String eventName;
  DateTime eventDate;
  String eventBio;
  String eventLocation;
  String eventImage;
  int eventCategory;
  String eventObjective;
  String eventLiveLink;
  String eventDetailHeader;
  int eventRegistrationAvailable;
  int eventMajorCategory;
  String name;
  String description;
  String icon;
  int parent_id;
  DateTime created_at;
  DateTime updated_at;

  Event(
      {required this.id,
      required this.eventName,
      required this.eventDate,
      required this.eventBio,
      required this.eventLocation,
      required this.eventImage,
      required this.eventCategory,
      required this.eventObjective,
      required this.eventLiveLink,
      required this.eventDetailHeader,
      required this.eventRegistrationAvailable,
      required this.eventMajorCategory,
      required this.name,
      required this.description,
      required this.icon,
      required this.parent_id,
      required this.created_at,
      required this.updated_at});

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        eventName: json["event_name"] ?? "",
        eventDate: json["event_date"] != null
            ? DateTime.parse(json["event_date"])
            : DateTime(2017, 9, 7, 17, 30),
        eventBio: json["event_bio"] ?? "",
        eventLocation: json["event_location"] ?? "",
        eventImage: json["event_image"] ?? "",
        eventCategory: json["event_category"] ?? 0,
        eventObjective: json["event_objective"] ?? "",
        eventLiveLink: json["event_live_link"] ?? "",
        eventDetailHeader: json["event_detail_header"] ?? "",
        eventRegistrationAvailable: json["event_registration_available"] ?? 0,
        eventMajorCategory: json["event_major_category"] ?? 0,
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        icon: json["icon"] ?? "",
        parent_id: json['parent_id'] ?? 0,
        created_at: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime(2017, 9, 7, 17, 30),
        updated_at: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime(2017, 9, 7, 17, 30),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_name": eventName,
        "event_date": eventDate?.toIso8601String(),
        "event_bio": eventBio,
        "event_location": eventLocation,
        "event_image": eventImage,
        "event_category": eventCategory,
        "event_objective": eventObjective,
        "event_live_link": eventLiveLink,
        "event_detail_header": eventDetailHeader,
        "event_registration_available": eventRegistrationAvailable,
    "event_major_category": eventMajorCategory,
        "name": name,
        "description": description,
        "icon": icon,
        "parent_id": parent_id,
        "created_at": created_at?.toIso8601String(),
        "updated_at": updated_at?.toIso8601String()
      };

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map["id"],
      eventName: map["event_name"] ?? "",
      eventDate: map["event_date"] != null
          ? DateTime.parse(map["event_date"])
          : DateTime(2017, 9, 7, 17, 30),
      eventBio: map["event_bio"] ?? "",
      eventLocation: map["event_location"] ?? "",
      eventImage: map["event_image"] ?? "",
      eventCategory: map["event_category"] ?? 0,
      eventObjective: map["event_objective"] ?? "",
      eventLiveLink: map["event_live_link"] ?? "",
      eventDetailHeader: map["event_detail_header"] ?? "",
      eventRegistrationAvailable: map["event_registration_available"] ?? 0,
      eventMajorCategory: map["event_major_category"] ?? 0,
      name: map["name"] ?? "",
      description: map["description"] ?? "",
      icon: map["icon"] ?? "",
      parent_id: map['parent_id'] ?? 0,
      created_at: map["created_at"] != null
          ? DateTime.parse(map["created_at"])
          : DateTime(2017, 9, 7, 17, 30),
      updated_at: map["updated_at"] != null
          ? DateTime.parse(map["updated_at"])
          : DateTime(2017, 9, 7, 17, 30),
    );
  }
}
