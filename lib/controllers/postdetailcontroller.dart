import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/controllers/socialprofilecontroller.dart';

import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';

import '../models/user.dart';
import '../utility/DBHelper.dart';
import '../utility/values.dart';

class PostDetailController extends GetxController {
  var posts = List<Posts>.empty().obs;
  var post_id = 0.obs;
  var post_type = 0.obs;
  var current_user_id = 0.obs;

  var id = 0.obs;
  var postCreatedBy = 0.obs;
  var postCreatedByUsername = "".obs;
  var postCreatedByUserIcon = "".obs;
  var postCreatedAt = DateTime.now().obs;
  var postCaption = "".obs;
  var likedByCurrentUser = false.obs;
  var isBookmarked = 0.obs;
  var postType = 1.obs;
  var totalLikes = 0.obs;
  var totalComments = 0.obs;
  var postMedia = List<PostMedia>.empty().obs;

  setCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();
    current_user_id.value = prefs.getInt("id")!;
  }

  @override
  void onInit() {

    setCurrentUser();
    // TODO: implement onInit
    super.onInit();
    var pageArgs = Get.arguments;
    print(pageArgs);
    post_id.value = pageArgs["post_id"];
    post_type.value = pageArgs["post_type"];
    fetchPostById(post_id.value,post_type.value);
  }

  void fetchPostById(int post__id,int post__type) async {
    await Get.delete<SocialProfileController>();
    var prefs = await SharedPreferences.getInstance();
    current_user_id.value = prefs.getInt("id")!;
    var allPosts = await RemoteServices.fetchPostsById(
        post__id, current_user_id.value, post__type);
    if (allPosts != null) {
      Posts response = Posts.fromJson(jsonDecode(allPosts));
      id.value = response.id;
      postCreatedBy.value = response.postCreatedBy;
      postCreatedByUsername.value = response.postCreatedByUsername;
      postCreatedByUserIcon.value = response.postCreatedByUserIcon;
      postCreatedAt.value = response.postCreatedAt;
      postCaption.value = response.postCaption;
      likedByCurrentUser.value = response.likedByCurrentUser;
      isBookmarked.value = response.isBookmarked;
      postType.value = response.postType;
      totalLikes.value = response.totalLikes;
      totalComments.value = response.totalComments;
      postMedia.value = response.postMedia;
      print("fetched data");
    }
  }

  void userGoingToSocialProfile(int postCreatedBy, var context) async {
    try {
      var response = await fetchUserById(postCreatedBy);
      if (response != null) {
        Get.toNamed("/social_profile", arguments: response);
      } else {
        Values.showMsgDialog("Community", "User Not Found", context, () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {}
  }

  static Future<User?> fetchUserById(int userId) async {
    final conn = DBHelper.instance;
    var dbclient = await conn.db;

    List<Map<String, dynamic>> userData = await dbclient!.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (userData.isNotEmpty) {
      // If user is found, return the user
      return User.fromJson(userData.first);
    } else {
      // If user is not found, return null
      return null;
    }
  }

  Like? filterLikes(List<Like> likes) {
    Like? targetLike;

    if (likes.isNotEmpty) {
      try {
        targetLike =
            likes.firstWhere((like) => like.likedBy == current_user_id.value);
      } catch (e) {
        // Handle the case when no element is found
        return null;
      }
    }

    return targetLike;
  }

  processLikes(int postId, bool isLiked) async {
    if (isLiked) {
      postLike(postId);
    } else {
      postUnlike(postId);
    }
    likedByCurrentUser.value =
        isLiked;
    posts.refresh();
  }

  static Future<bool> postLike(var postId) async {
    var response = await RemoteServices.postLike(postId);
    if (response['success']) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> postUnlike(var postId) async {
    var response = await RemoteServices.postUnlike(postId);
    if (response['success']) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> bookmarkPost(int postId) async {
    var response = await RemoteServices.bookmarkPost(postId);
    if (response['success']) {
      posts.singleWhere((element) => element.id == postId).isBookmarked = 1;
      posts.refresh();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unBookmarkPost(int postId) async {
    var response = await RemoteServices.unBookmarkPost(postId);
    if (response['success']) {
      posts.singleWhere((element) => element.id == postId).isBookmarked = 0;
      posts.refresh();
      return true;
    } else {
      return false;
    }
  }
}
