// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

List<User> usersFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String userName;
  String number;
  int userRole;
  String image;
  int gender;
  int married;
  String about;
  String height;
  String weight;
  String age;
  dynamic userDoc;
  DateTime birthday;
  String addressLine1;
  String city;
  String state;
  String pincode;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userName,
    required this.number,
    required this.userRole,
    required this.image,
    required this.gender,
    required this.married,
    required this.about,
    required this.height,
    required this.weight,
    required this.age,
    required this.userDoc,
    required this.birthday,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        email: json["email"] ?? "",
        userName: json['user_name'] ?? "",
        number: json["number"] ?? "",
        userRole: json["user_role"] ?? 0,
        image: json["image"] ?? "",
        gender: json["gender"] ?? 0,
        married: json["married"] ?? 0,
        about: json["about"] ?? "",
        height: json["height"] ?? "",
        weight: json["weight"] ?? "",
        age: json["age"] ?? "",
        userDoc: json["user_doc"] ?? "",
        birthday: json["birthday"] != null
            ? DateTime.parse(json["birthday"])
            : DateTime(2017, 9, 7, 17, 30),
        addressLine1: json["address_line1"] ?? "",
        city: json["city"] ?? "",
        state: json["state"] ?? "",
        pincode: json["pincode"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "user_name": userName,
        "number": number,
        "user_role": userRole,
        "image": image,
        "gender": gender,
        "married": married,
        "about": about,
        "height": height,
        "weight": weight,
        "age": age,
        "user_doc": userDoc,
        "birthday": birthday.toIso8601String(),
        "address_line1": addressLine1,
        "city": city,
        "state": state,
        "pincode": pincode,
      };
}
