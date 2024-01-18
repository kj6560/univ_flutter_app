import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/EventPartner.dart';
import 'package:univ_app/models/UserFile.dart';
import 'package:univ_app/models/category.dart';
import 'package:univ_app/models/event.dart';
import 'package:univ_app/models/sliders.dart';
import 'package:univ_app/models/user.dart';
import 'package:univ_app/utility/values.dart';

import '../models/EventFile.dart';

class RemoteServices {
  static Future<bool> hasInternet() async{
    return await InternetConnectionChecker().hasConnection;
  }
  static var client = http.Client();

  static Future<List<Sliders>?> fetchSliders() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    String urL = Values.sliderUrl;
    var response = await http.get(Uri.parse(urL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return slidersFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<Category>?> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    String urL = Values.categoriesUrl;
    var response = await http.get(Uri.parse(urL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return categoryFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<Event>?> fetchEvents() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    String urL = Values.eventsUrl;
    var response = await http.get(Uri.parse(urL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return eventFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static fetchEventDetail(var event_id) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    String urL = "${Values.eventsUrl}?id=" + event_id;
    var response = await http.get(Uri.parse(urL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return jsonString;
    } else {
      //show error message
      return null;
    }
  }

  static fetchEventPartners(var event_id) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    String urL = "${Values.eventPartnerUrl}?event_id=" + event_id;
    var response = await http.get(Uri.parse(urL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return eventPartnerFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static fetchEventFiles(var event_id) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    String urL = "${Values.eventFiles}?event_id=$event_id";
    var response = await http.get(Uri.parse(urL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return eventFileFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static fetchUserFiles(var user_id, var type) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    String urL = "${Values.userFiles}?user_id=$user_id&file_type=$type";
    var response = await http.get(Uri.parse(urL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return userFileFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static logoutUser(var user_id) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    String urL = "${Values.logoutUrl}?user_id=$user_id&token=$token";
    var response = await http.post(Uri.parse(urL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var data = jsonDecode(jsonString);
      if (data['success']) {
        return true;
      } else {
        return false;
      }
    } else {
      //show error message
      return null;
    }
  }

  static Future<String?> fetchUserPerformance(var user_id) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    String urL = "${Values.userPerformanceUrl}?user_id=$user_id";
    var response = await http.get(Uri.parse(urL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return jsonString;
    } else {
      //show error message
      return null;
    }
  }

  static Future<bool?> updateProfile(var payload) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      http.Response response = await http.post(Uri.parse(Values.setProfile),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: payload);
      if (response.statusCode == 200) {
        var responseObject = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        User user = User.fromJson(responseObject['user']);
        prefs.setInt("id", user.id);
        prefs.setBool("show_welcome", false);
        prefs.setString("email", user.email);
        prefs.setString("first_name", user.firstName);
        prefs.setString("last_name", user.lastName);
        prefs.setString("image", user.image ?? "");
        prefs.setString("about", user.about);
        prefs.setString("number", user.number);
        prefs.setInt("user_role", user.userRole);
        prefs.setInt("gender", user.gender);
        prefs.setInt("married", user.married);
        prefs.setString("height", user.height);
        prefs.setString("weight", user.weight);
        prefs.setString("age", user.age);
        prefs.setString("user_doc", user.userDoc);
        prefs.setString("birthday", user.birthday.toIso8601String());
        prefs.setString("address_line1", user.addressLine1);
        prefs.setString("city", user.city);
        prefs.setString("state", user.state);
        prefs.setString("pincode", user.pincode);
        return true;
      } else {
        return false;
      }
    } catch (e) {
    } finally {}
  }

  static Future<bool?> registerUser(var firstName, var lastName, var email,
      var phoneNumber, var password) async {
    try {
      http.Response response = await http.post(Uri.parse(Values.register),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'phone': phoneNumber,
            'password': password
          }));
      if (response.statusCode == 200) {
        var responseObj = jsonDecode(response.body);
        if (responseObj['success']) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
    } finally {}
  }

  static registerForEvents(var data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      http.Response response =
          await http.post(Uri.parse(Values.registerForEvents),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: data);

      if (response.statusCode == 200) {
        var responseObj = jsonDecode(response.body);
        return responseObj;
      }
    } catch (e) {}
  }

  static fetchTemperature(double latitude, double longitude) async {
    String mUrl =
        "https://weatherapi-com.p.rapidapi.com/current.json?q=${latitude}%2C${longitude}";
    try {
      http.Response response =
          await http.get(Uri.parse(mUrl), headers: <String, String>{
        'X-RapidAPI-Key': '0ef8897533msh92a58facfc04e7cp1bbe46jsn233b9d65094d',
        'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com'
      });
      if (response.statusCode == 200) {
        var responseObj = jsonDecode(response.body);
        return responseObj;
      }
    } catch (e) {
    } finally {}
  }

  static Future<String?> fetchPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");

      http.Response response = await http.get(
        Uri.parse(Values.fetchPosts),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print(e);
    }
  }
}
