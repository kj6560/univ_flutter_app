// To parse this JSON data, do
//
//     final eventPartner = eventPartnerFromJson(jsonString);

import 'dart:convert';

List<EventPartner> eventPartnerFromJson(String str) => List<EventPartner>.from(json.decode(str).map((x) => EventPartner.fromJson(x)));

String eventPartnerToJson(List<EventPartner> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventPartner {
  int id;
  int eventId;
  String partnerName;
  String partnerLogo;
  dynamic createdAt;
  dynamic updatedAt;

  EventPartner({
    required this.id,
    required this.eventId,
    required this.partnerName,
    required this.partnerLogo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventPartner.fromJson(Map<String, dynamic> json) => EventPartner(
    id: json["id"],
    eventId: json["event_id"],
    partnerName: json["partner_name"],
    partnerLogo: json["partner_logo"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_id": eventId,
    "partner_name": partnerName,
    "partner_logo": partnerLogo,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
