// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

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
  String name;
  String description;
  String icon;
  Event({
    required this.id,
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
    required this.name,
    required this.description,
    required this.icon,
  });

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
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        icon: json["icon"] ?? "",
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
        "name": name,
        "description": description,
        "icon": icon,
      };
}
