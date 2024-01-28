import 'dart:convert';

import 'package:get/get.dart';

import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';

import '../models/user.dart';

class CommunityController extends GetxController {
  var posts = <Posts>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchPosts();
  }

  void fetchPosts() async {
    var allPosts = await RemoteServices.fetchPosts();
    if (allPosts != null) {
      var response = postFromJson(allPosts);
      posts.value = response;
    }
  }

  void userGoingToSocialProfile(int postCreatedBy) async {
    try {
      User user;
      var response = await RemoteServices.fetchUserById(postCreatedBy);
      if (response != null) {
        user = userFromJson(response);
        print(user.firstName);
        Get.offAllNamed("/social_profile", arguments: user);
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }
}
