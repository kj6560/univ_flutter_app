import 'dart:convert';

List<Sliders> slidersFromJson(String str) =>
    List<Sliders>.from(json.decode(str).map((x) => Sliders.fromJson(x)));

String slidersToJson(List<Sliders> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sliders {
  String image;

  Sliders({
    required this.image,
  });

  factory Sliders.fromJson(Map<String, dynamic> json) => Sliders(
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}
