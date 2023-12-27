import 'dart:convert';

import 'package:get/get.dart';
import 'package:univ_app/models/DynamicModel.dart';
import 'package:univ_app/models/category.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';

class CommunityController extends GetxController {
  var posts = List<Post>.empty();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchPosts();
  }

  void fetchPosts() async {
    var allPosts = await RemoteServices.fetchPosts();
    if (allPosts != null) {
      print(allPosts);
      posts = postFromJson(allPosts);
      update();
    }
  }
}
