import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

class LoginController extends GetxController {
  bool isLoading = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void login(String email, String password, var context) async {
    try {
      var response = await RemoteServices.login(email, password);
      if (!response!['error']) {
        final prefs = await SharedPreferences.getInstance();


        final Map<String, dynamic> userObj = response['user'];

        prefs.setString("token", response['token']);
        prefs.setInt("id", userObj['id']);
        prefs.setString("email", userObj['email']);
        prefs.setString("first_name", userObj['first_name']);
        prefs.setString("last_name", userObj['last_name']);
        prefs.setString("image", userObj['image'] ?? "");
        prefs.setString("about", userObj['about'] ?? "Update Your Profile");
        prefs.setString("number", userObj['number'] ?? "");
        prefs.setInt("user_role", userObj['user_role'] ?? "");
        prefs.setInt("gender", userObj['gender'] ?? 2);
        prefs.setInt("married", userObj['married'] ?? 2);
        prefs.setString("height", userObj['height'] ?? "");
        prefs.setString("weight", userObj['weight'] ?? "");
        prefs.setString("age", userObj['age'] ?? "");
        prefs.setString("user_doc", userObj['user_doc'] ?? "");
        prefs.setString("birthday", userObj['birthday'] ?? "");
        prefs.setString("address_line1", userObj['address_line1'] ?? "");
        prefs.setString("city", userObj['city'] ?? "");
        prefs.setString("state", userObj['state'] ?? "");
        prefs.setString("pincode", userObj['pincode'] ?? "");


        Get.offAllNamed("/home");
      } else {
        Values.showMsgDialog("Login", response['message'], context, () {
          Navigator.pop(context);
        });
      }
    } catch (e) {
      Values.showInternetErrorDialog("Login",e, context);
    }
  }
}