import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';

import '../models/user.dart';
import '../utility/DBHelper.dart';
import '../utility/values.dart';

class ReelsController extends GetxController {
  var posts = List<Posts>.empty().obs;
  var current_user_id = 0.obs;

  setCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();
    current_user_id.value = prefs.getInt("id")!;
  }

  @override
  void onInit() {
    setCurrentUser();
    // TODO: implement onInit
    super.onInit();
    fetchPosts();
  }


  void fetchPosts() async {
    var prefs = await SharedPreferences.getInstance();

    current_user_id.value = prefs.getInt("id")!;
    var selfReel = Get.arguments != null && Get.arguments["self"] == 1 ? 1 : 0;
    var allPosts = await RemoteServices.fetchReels(current_user_id.value,
        selfReel: selfReel);

    if (allPosts != null) {
      var response = postFromJson(allPosts);
      var topReelId =
          Get.arguments != null ? Get.arguments["post_id"] : response[0].id;
      if (topReelId != null) {
        // Find the top reel and move it to the top of the list
        var topReel =
            response.singleWhere((element) => element.id == topReelId);
        response.remove(topReel);
        response.insert(0, topReel);
      }

      // Sort the list based on post ID
      response.sort((a, b) => a.id.compareTo(b.id));

      posts.value = response;
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
    posts.singleWhere((element) => element.id == postId).likedByCurrentUser =
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
