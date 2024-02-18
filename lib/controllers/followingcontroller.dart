import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/services/remote_services.dart';
import '../models/user.dart';
import '../utility/values.dart';

class FollowingController extends GetxController{
  var followers = <User>[].obs;
  var userList = <User>[];
  RxString user_name = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchFollowers(user_name.value);
  }

  void fetchFollowers(String user__name) async {
    var prefs = await SharedPreferences.getInstance();

    var current_user_id = prefs.getInt("id")!;

    user_name.value = user__name;
    var followerOf = Get.arguments != null ? Get.arguments.id : current_user_id;
    print(followerOf);
    var response = await RemoteServices.fetchFollowings(followerOf);
    if (response != null) {
      var followersOfUser = usersFromJson(response);
      if (followersOfUser != null) {
        for (User user in followersOfUser) {
          try {
            if (user.image != null || user.image != "") {
              Values.cacheFile('${Values.profilePic}${user.image}');
            }
          } catch (e) {}
        }
        followers.value = followersOfUser;
        userList = followers.value;
      }
    }
  }

  void filterUsers(String query) {
    followers.value = userList
        .where((element) =>
        element.userName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}