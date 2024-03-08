import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:univ_app/services/remote_services.dart';

class UserProfileController extends GetxController {
  String email = "";
  String first_name = "";
  String last_name = "";
  String image = "";
  String about = "";
  String number = "";
  int user_role = 0;
  int gender = 0;
  int married = 0;
  String height = "";
  String weight = "";
  String age = "";
  String user_doc = "";
  String birthday = "";
  String address_line1 = "";
  String city = "";
  String state = "";
  String pincode = "";

  @override
  void onInit() {
    // TODO: implement onInit
    fetchProfileData();
    super.onInit();

  }

  void fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt("id");
    var profileData = await RemoteServices.fetchProfile(id);

    if (profileData != null) {
      prefs.setString("first_name", profileData.firstName);
      prefs.setString("last_name", profileData.lastName);
      prefs.setString("about", profileData.about);
      prefs.setString("number", profileData.number);
      prefs.setInt("gender", profileData.gender);
      prefs.setInt("married", profileData.married);
      prefs.setString("height", profileData.height.toString());
      prefs.setString("weight", profileData.weight.toString());
      prefs.setString("age", calculateAge(profileData.birthday).toString());
      prefs.setString("user_doc", user_doc);
      String formattedDate = DateFormat('y-MM-d').format(profileData.birthday);
      prefs.setString("birthday", formattedDate);
      prefs.setString("address_line1", profileData.addressLine1);
      prefs.setString("city", profileData.city);
      prefs.setString("state", profileData.state);
      prefs.setString("pincode", profileData.pincode);
    }
    email = prefs.getString("email")!;
    first_name = prefs.getString("first_name")!;
    last_name = prefs.getString("last_name")!;
    image = prefs.getString('image')!;
    about = prefs.getString("about")!;
    number = prefs.getString("number")!;
    user_role = prefs.getInt("user_role")!;
    gender = prefs.getInt("gender")!;
    married = prefs.getInt("married")!;
    height = prefs.getString("height")!;
    weight = prefs.getString("weight")!;
    age = prefs.getString("age")!;
    user_doc = prefs.getString("user_doc")!;
    birthday = prefs.getString("birthday")!;
    address_line1 = prefs.getString("address_line1")!;
    city = prefs.getString("city")!;
    state = prefs.getString("state")!;
    pincode = prefs.getString("pincode")!;
    update();
  }

  updateProfile(
      var first_name,
      var last_name,
      var about,
      var number,
      var _gender,
      var _married,
      var height,
      var weight,
      var address_line1,
      var city,
      var state,
      var pincode,
      DateTime dob,
      var context) async {
    final prefs = await SharedPreferences.getInstance();
    int? user_id = prefs.getInt("id");
    String? email = prefs.getString("email");
    prefs.setString("first_name", first_name);
    prefs.setString("last_name", last_name);
    prefs.setString("about", about);
    prefs.setString("number", number);
    prefs.setInt("gender", gender);
    prefs.setInt("married", married);
    prefs.setString("height", height.toString());
    prefs.setString("weight", weight.toString());
    prefs.setString("age", calculateAge(dob).toString());
    prefs.setString("user_doc", user_doc);
    String formattedDate="";
    if(birthday.length>=10){
      formattedDate = DateTime.parse(birthday).toIso8601String();
      prefs.setString("birthday", formattedDate);
    }


    prefs.setString("address_line1", address_line1);
    prefs.setString("city", city);
    prefs.setString("state", state);
    prefs.setString("pincode", pincode);

    Map<String, dynamic> jsonData = {
      "personal_details": {
        "user_id": user_id,
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "number": number,
        "gender": gender,
        "height": height,
        "weight": weight,
        "married": married,
        "about": about,
        "birthday": formattedDate
      },
      "address_details": {
        "address_line1": address_line1,
        "city": city,
        "state": state,
        "pincode": pincode
      }
    };

    // Convert Map to JSON string
    String jsonPayload = jsonEncode(jsonData);
    bool? updated = await RemoteServices.updateProfile(jsonPayload);
    if (updated! && updated) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Profile Update'),
            content: const Text("Profile update successful."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Get.offAllNamed("/user_profile");
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Profile Update'),
            content: const Text("Profile update failed."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  int calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }
}
