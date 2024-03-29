import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:univ_app/controllers/socialprofilecontroller.dart';

import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';

import '../models/user.dart';
import '../utility/DBHelper.dart';
import '../utility/values.dart';

class CommunityController extends GetxController {
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
    var allPosts = await RemoteServices.fetchPosts(current_user_id.value);
    print(allPosts);
    if (allPosts != null) {
      var response = postFromJson(allPosts);
      posts.value = response;
    }
  }

  void userGoingToSocialProfile(int postCreatedBy, var context) async {
    try {
      var response = await fetchUserById(postCreatedBy);
      await Get.delete<SocialProfileController>();
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
      return User.fromJson(userData.first);
    } else {
      var resp = await RemoteServices.fetchUserById(userId);
      return User.fromJson(jsonDecode(resp!));
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
