import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';

import '../models/user.dart';
import '../utility/DBHelper.dart';
import '../utility/values.dart';

class CommunityController extends GetxController {
  var posts = <Posts>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchPosts();
  }

  void fetchPosts() async {
    List<Posts> postsInDb = await getPosts();
    var allPosts = await RemoteServices.fetchPosts();
    if (allPosts != null) {
      var response = postFromJson(allPosts);

      if (response.length != postsInDb.length) {
        for (Posts post in response) {
          await insertPost(post);
        }
        posts.value = response;
      } else if (response.length == postsInDb.length) {
        posts.value = postsInDb;
      }
    } else {
      posts.value = postsInDb;
    }
  }

  void userGoingToSocialProfile(int postCreatedBy, var context) async {
    try {
      var response = await fetchUserById(postCreatedBy);
      if (response != null) {
        Get.offAllNamed("/social_profile", arguments: response);
      }else{
        Values.showMsgDialog("Community", "User Not Found", context, () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {}
  }

  static Future<void> insertPost(Posts post) async {
    final conn = DBHelper.instance;
    var dbclient = await conn.db;

    // Check if the post already exists in the 'posts' table
    List<Map<String, dynamic>> existingPosts = await dbclient!.query(
      'posts',
      where: 'id = ?',
      whereArgs: [post.id],
    );

    if (existingPosts.isEmpty) {
      // If the post does not exist, insert it into the 'posts' table
      int postId = await dbclient.insert('posts', {
        'id': post.id,
        'post_created_by': post.postCreatedBy,
        'post_created_by_username': post.postCreatedByUsername,
        'post_created_at': post.postCreatedAt.toIso8601String(),
        'post_caption': post.postCaption,
        'post_type': post.postType,
        'post_created_by_user_icon': post.postCreatedByUserIcon,
      });

      if (post.postMedia != null) {
        for (var media in post.postMedia) {
          await dbclient.insert('media', {
            'post_id': postId,
            'media_name': media.mediaName,
            'media_type': media.mediaType,
            'media_position': media.mediaPosition,
          });
        }
      }

      if (post.comments != null) {
        for (var comment in post.comments) {
          await dbclient.insert('comments', {
            'post_id': postId,
            'comment': comment.comment,
            'comment_by': comment.commentBy,
            'comment_by_username': comment.commentByUsername,
            'is_parent': comment.isParent,
            'parent_id': comment.parentId,
            'is_available': comment.isAvailable,
            'created_at': comment.createdAt.toIso8601String(),
          });
        }
      }

      if (post.likes != null) {
        for (var like in post.likes) {
          await dbclient.insert('likes', {
            'post_id': postId,
            'liked_by': like.likedBy,
            'liked_by_username': like.likedByUsername,
            'created_at': like.createdAt.toIso8601String(),
          });
        }
      }
    }
  }

  static Future<List<Posts>> getPosts() async {
    final conn = DBHelper.instance;
    var dbclient = await conn.db;
    List<Map<String, dynamic>> postsData = await dbclient!.query('posts');

    List<Posts> posts = [];

    for (var postData in postsData) {
      List<Map<String, dynamic>> mediaData = await dbclient
          .query('media', where: 'post_id = ?', whereArgs: [postData['id']]);

      List<Map<String, dynamic>> commentsData = await dbclient
          .query('comments', where: 'post_id = ?', whereArgs: [postData['id']]);

      List<Map<String, dynamic>> likesData = await dbclient
          .query('likes', where: 'post_id = ?', whereArgs: [postData['id']]);

      List<PostMedia> postMedia =
          mediaData.map((media) => PostMedia.fromJson(media)).toList();

      List<Comment> comments =
          commentsData.map((comment) => Comment.fromJson(comment)).toList();

      List<Like> likes = likesData.map((like) => Like.fromJson(like)).toList();

      Posts post = Posts(
        id: postData['id'],
        postCreatedBy: postData['post_created_by'],
        postCreatedByUsername: postData['post_created_by_username'],
        postCreatedByUserIcon: postData['post_created_by_user_icon'],
        postCreatedAt: DateTime.parse(postData['post_created_at']),
        postCaption: postData['post_caption'],
        postType: postData['post_type'],
        postMedia: postMedia,
        comments: comments,
        likes: likes,
      );

      posts.add(post);
    }

    return posts;
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
}
