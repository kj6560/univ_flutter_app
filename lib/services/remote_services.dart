import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/EventPartner.dart';
import 'package:univ_app/models/UserFile.dart';
import 'package:univ_app/models/category.dart';
import 'package:univ_app/models/event.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/models/sliders.dart';
import 'package:univ_app/models/user.dart';
import 'package:univ_app/utility/values.dart';

import '../models/EventFile.dart';

class RemoteServices {
  static Future<bool> hasInternet() async {
    return await InternetConnectionChecker().hasConnection;
  }

  static var client = http.Client();

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    var mBody = jsonEncode({'email': email, 'password': password});
    print(mBody);
    final response = await http.post(
      Uri.parse('${Values.baseUrl}/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: mBody,
    );

    final Map<String, dynamic> responseObject = json.decode(response.body);
    if (responseObject != null) {
      return responseObject;
    }
    return null;
  }

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
      return null;
    }
  }

  static Future<List<Sliders>?> fetchAppSliders() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    String urL = Values.appSliderUrl;
    var response = await http.get(Uri.parse(urL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return slidersFromJson(jsonString);
    } else {
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
      return null;
    }
  }

  static Future<List<Category>> fetchEsportsCategories() async {
    final prefs = await SharedPreferences.getInstance();
    var all_categories = List<Category>.empty();
    var token = prefs.getString("token");
    String urL = Values.esportsCategoriesUrl;
    var response = await http.get(Uri.parse(urL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      all_categories =  categoryFromJson(jsonString);
    }
    return all_categories;
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

  static Future<List<Event>?> fetchEsportsEvents() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    String urL = Values.esportsEventsUrl;
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
    String urL = "${Values.eventsUrl}?event_id=" + event_id;
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

  static archiveUserFile(int id, int user_id) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString("token");
      Uri url =
          Uri.parse("${Values.archiveUserFile}?file_id=$id&user_id=$user_id");

      // Send the request
      http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        var resp = json.decode(response.body);

        if (resp['success']) {
          return true;
        } else {
          return false;
        }
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
    return false;
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

  static Future<String?> registerUser(var firstName, var lastName, var email,
      var phoneNumber, var password) async {
    try {
      var data = jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phoneNumber,
        'password': password
      });
      http.Response response = await http.post(Uri.parse(Values.register),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: data);
      var responseObj = jsonDecode(response.body);
      return responseObj["msg"];
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
        var temp = responseObj['current']['temp_c'];
        var city = responseObj['location']['region'];
        var now = DateTime.now();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("fetch_datetime",now.toIso8601String());
        prefs.setString("city_user",city);
        prefs.setDouble("temp_user",temp);
        return responseObj;
      }
    } catch (e) {
    } finally {}
  }

  static Future<String?> fetchPosts(int current_user_id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      print(Uri.parse(Values.fetchPosts + "?user_id=$current_user_id"));
      http.Response response = await http.get(
        Uri.parse(Values.fetchPosts + "?user_id=$current_user_id"),
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

  static Future<String?> fetchReels(int current_user_id,{var selfReel = 0}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      print(Uri.parse(
          Values.fetchPosts + "?user_id=${current_user_id}&post_type=2&self_reel=${selfReel}"));
      http.Response response = await http.get(
        Uri.parse(
            Values.fetchPosts + "?user_id=${current_user_id}&post_type=2&self_reel=${selfReel}"),
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

  static Future<int> createPost(
      List<PostMedia> mediaFiles, String caption, int post_type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt("id");
      Values.checkAndRequestPermissions();
      var data = {
        "post_created_by": id,
        "post_created_at": DateTime.now().toIso8601String(),
        // Convert to ISO8601 string
        "post_caption": caption,
        "post_type": post_type
      };

      var token = prefs.getString("token");

      http.Response response = await http.post(
        Uri.parse(Values.createPost),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );

      if (response.statusCode == 200) {
        var responseObj = jsonDecode(response.body);
        return responseObj['post_id'];
      }
    } catch (e) {
      print(e);
    }
    return 0;
  }

  static Future<bool> deletePost(int post_id,
      {bool permanently = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString("token");
      Uri url = Uri.parse("${Values.deletePost}?post_id=$post_id&permanently=$permanently");
      print(url);
      // Send the request
      http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        var resp = json.decode(response.body);

        if (resp['success']) {
          return true;
        } else {
          return false;
        }
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
    return false;
  }

  static void showSnackBar(BuildContext context) async {
    if (!await RemoteServices.hasInternet()) {
      const snackBar = SnackBar(
        content: Text('No Internet!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  static Future<bool> uploadCertificate(String type, XFile? imageFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = await prefs.getInt("id");
      String? _token = await prefs.getString("token");
      if (imageFile == null) {
        return false;
      }

      Uri url = Uri.parse("${Values.userImageUpload}?user_id=${id}&type=3");
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $_token';
      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        type,
        imageFile!.path,
      ));
      // Send the request
      var response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle the error
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  static Future<User?> fetchProfile(int? id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");

      http.Response response = await http.get(
        Uri.parse("${Values.fetchProfile}?user_id=$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        var resp = jsonDecode(response.body);
        return User.fromJson(resp['user']);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<String?> fetchUsers(String userName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");

      http.Response response = await http.get(
        Uri.parse("${Values.fetchUsers}?user_name=$userName"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      }
    } catch (e) {
      print(e);
    }
  }

  static followUser(int? follower_id, int followed_id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var data = {
        "follow_user": followed_id,
        "followed_by": follower_id,
      };

      var token = prefs.getString("token");

      http.Response response = await http.post(
        Uri.parse(Values.followUser),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static fetchFollowerData(int followed_id, int current_user_profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt("id");
      var data = {
        "check_user": followed_id,
        "current_user_id": id,
        "current_user_profile": current_user_profile
      };

      var token = prefs.getString("token");

      http.Response response = await http.post(
        Uri.parse(Values.fetchFollowerData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<String?> fetchUserById(int id, var context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");

      http.Response response = await http.get(
        Uri.parse("${Values.fetchUserById}?id=$id"),
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
      Values.showInternetErrorDialog("Forgot Password", e, context);
    }
  }

  static Future<Object> uploadPostMedia(
      List<PostMedia> mediaFiles, int post_type, int post_id) async {
    final prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt("id");
    String? token = prefs.getString("token");
    Uri url = Uri.parse("${Values.uploadPostMedia}?user_id=${id}");
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    for (var element in mediaFiles) {
      var path =
          element.path ?? ""; // Use the null-aware operator to handle null path
      print(path);
      // Use 'await' here to ensure the asynchronous operation completes before moving to the next iteration
      request.files.add(await http.MultipartFile.fromPath("media[]", path));
    }
    request.fields["post_id"] = post_id.toString();
    request.fields['media_created_by'] = id.toString();
    try {
      // Send the request
      var response = await request.send();
      String responseBody = await utf8.decodeStream(response.stream);
      var parsedResponse = jsonDecode(responseBody);
      var rsp = {
        "success": parsedResponse["status"] == 200 ? true : false,
        "message": parsedResponse["message"]
      };
      return rsp;
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  static Future<Object> uploadVideoFile(int post_id, String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = await prefs.getInt("id");
      String? _token = await prefs.getString("token");
      if (path == null) {
        // No file selected, handle this as needed
        return false;
      }

      Uri url = Uri.parse("${Values.uploadUserVideos}?user_id=${id}");
      print(path);
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $_token';
      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        "video_file",
        path,
      ));
      request.fields["post_id"] = post_id.toString();
      request.fields['media_created_by'] = id.toString();
      // Send the request
      var response = await request.send();
      String responseBody = await utf8.decodeStream(response.stream);
      var parsedResponse = jsonDecode(responseBody);
      var rsp = {
        "success": parsedResponse["status"] == 200 ? true : false,
        "message": parsedResponse["message"]
      };
      return rsp;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  static Future<String?> fetchTopQuote() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");

      http.Response response = await http.get(
        Uri.parse(Values.fetchTopQuote),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        var respObj = jsonDecode(response.body);
        if (!respObj['error']) {
          return respObj['message'];
        } else {
          return "It's a great day to run";
        }
      }
    } catch (e) {
      return "It's a great day to run";
    }
  }

  static unFollowUser(int? follower_id, int followed_id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var data = {
        "unfollow_user": followed_id,
        "unfollowed_by": follower_id,
      };

      var token = prefs.getString("token");
      print(Uri.parse(Values.unFollowUser));
      http.Response response = await http.post(
        Uri.parse(Values.unFollowUser),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static fetchComments(int post_id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var data = {"post_id": post_id};
      var token = prefs.getString("token");
      http.Response response = await http.post(
        Uri.parse(Values.fetchComments),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print(e);
    }
  }

  static postComment(postId, comment) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt("id");
      var data = {
        "post_id": postId,
        "user_id": id,
        "comment": comment,
        "is_parent": 1,
        "parent_id": 0
      };
      var token = prefs.getString("token");
      http.Response response = await http.post(
        Uri.parse(Values.commentPost),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  static postLike(postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt("id");
      var data = {
        "post_id": postId,
        "user_id": id,
      };
      var token = prefs.getString("token");
      http.Response response = await http.post(
        Uri.parse(Values.likePost),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  static postUnlike(postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt("id");
      var data = {
        "post_id": postId,
        "user_id": id,
      };
      var token = prefs.getString("token");
      http.Response response = await http.post(
        Uri.parse(Values.unlikePost),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  static bookmarkPost(postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt("id");
      var data = {
        "bookmark_post_id": postId,
        "bookmark_by": id,
      };
      var token = prefs.getString("token");
      http.Response response = await http.post(
        Uri.parse(Values.bookmarkPost),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  static unBookmarkPost(postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt("id");
      var data = {
        "bookmark_post_id": postId,
        "bookmark_by": id,
      };
      var token = prefs.getString("token");
      http.Response response = await http.post(
        Uri.parse(Values.unBookmarkPost),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  static fetchUserPost(int user_id, int post_type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var data = {"user_id": user_id, "post_type": post_type};
      var token = prefs.getString("token");
      http.Response response = await http.post(
        Uri.parse(Values.fetchUserPost),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print(e);
    }
  }

  static fetchPostsById(int postId, int post_type, int user_id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var data = {
        "user_id": user_id,
        "post_type": post_type,
        "post_id": postId
      };
      var token = prefs.getString("token");
      http.Response response = await http.post(
        Uri.parse(Values.fetchPostsById),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data), // Convert the data map to JSON string
      );

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print(e);
    }
  }

  static fetchFollowers(var id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      http.Response response = await http.post(
        Uri.parse("${Values.fetchFollowers}?user_id=$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      }
    } catch (e) {

    }
  }

  static fetchFollowings(var id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      http.Response response = await http.post(
        Uri.parse("${Values.fetchFollowings}?user_id=$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      }
    } catch (e) {

    }
  }
  static Future<String?> fetchEsportsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      http.Response response = await http.get(
        Uri.parse(Values.fetchEsportsContent ),
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
