import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

import '../models/user.dart';

class SocialProfileController extends GetxController {
  var profilePic = "";
  var profileName = "";
  var about = "";
  var loggedout = false;
  var following = 0;
  var followers = 0;
  var followed = 0;
  var check_user = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchFollowersData();
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() async {
    User? data = Get.arguments;
    if (data != null) {
      profilePic = (data.image)!;
      profileName = "${(data.firstName)!} ${(data.lastName)!}";
      about = (data.about)!;
      check_user = data.id;
      update();
    } else {
      final prefs = await SharedPreferences.getInstance();
      profilePic = (prefs.getString('image'))!;
      profileName =
          "${(prefs.getString("first_name"))!} ${(prefs.getString("last_name"))!}";
      about = (prefs.getString("about"))!;
      check_user = prefs.getInt("id")!;
      update();
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    int? id = await prefs.getInt("id");
    if (id != 0) {
      prefs.setString("token", "");
      prefs.setInt("id", 0);
      prefs.setString("email", "");
      prefs.setString("first_name", "");
      prefs.setString("last_name", "");
      prefs.setString("image", "");
      prefs.setString("about", "");
      prefs.setString("number", "");
      prefs.setInt("user_role", 0);
      prefs.setInt("gender", 0);
      prefs.setInt("married", 0);
      prefs.setString("height", "");
      prefs.setString("weight", "");
      prefs.setString("age", "");
      prefs.setString("user_doc", "");
      prefs.setString("birthday", "");
      prefs.setString("address_line1", "");
      prefs.setString("city", "");
      prefs.setString("state", "");
      prefs.setString("pincode", "");
      await prefs.clear();
      RemoteServices.logoutUser(id);
      Get.offAllNamed("/login");
    }
  }

  void followUser(int id, var context) async {
    final prefs = await SharedPreferences.getInstance();
    int? follower_id = prefs.getInt("id");
    User? user = Get.arguments;
    int followed_id = user!.id;
    var response = await RemoteServices.followUser(follower_id, followed_id);
    if (response['success'] != null) {
      Values.showMsgDialog(
          "Followed", "You are now catching up with ${user.firstName}", context,
          () {
        Get.offAllNamed("/social_profile",arguments: user);
      });
    } else {
      Values.showMsgDialog("Failed", response['message'], context, () {
        Get.offAllNamed("/search");
      });
    }
  }

  void fetchFollowersData() async {
    User? user = Get.arguments;
    int followed_id = user != null ? user.id : 0;
    int current_user_profile = followed_id != 0 ? 0 : 1;
    var response = await RemoteServices.fetchFollowerData(followed_id,current_user_profile);

    if (response != null) {
      followers = response['total_followers'];
      following = response['total_following'];
      followed = response['is_following'];
    }
    update();
  }
}
