import 'dart:convert';

import 'package:get/get.dart';

List<Posts> postFromJson(String str) =>
    List<Posts>.from(json.decode(str).map((x) => Posts.fromJson(x)));

List<Comment> commentFromJson(String str) =>
    List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

class Posts {
  int id;
  int postCreatedBy;
  String postCreatedByUsername;
  String postCreatedByUserIcon;
  DateTime postCreatedAt;
  String postCaption;
  bool likedByCurrentUser;
  int isBookmarked;
  int postType;
  int totalLikes;
  int totalComments;
  List<PostMedia> postMedia;

  Posts({
    required this.id,
    required this.postCreatedBy,
    required this.postCreatedByUsername,
    required this.postCreatedByUserIcon,
    required this.postCreatedAt,
    required this.postCaption,
    required this.likedByCurrentUser,
    required this.isBookmarked,
    required this.postType,
    required this.postMedia,
    required this.totalLikes,
    required this.totalComments,
  });

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
        id: json['id'],
        postCreatedBy: json['post_created_by'] ?? 0,
        postCreatedByUsername: json['post_created_by_username'] ?? "",
        postCreatedByUserIcon: json['post_created_by_user_icon'] ??"",
        postCreatedAt: json['post_created_at'] != null
            ? DateTime.parse(json['post_created_at'])
            : DateTime(2017, 9, 7, 17, 30),
        // Adjust default value accordingly
        postCaption: json['post_caption'] ?? "",
        likedByCurrentUser: json['liked_by_current_user'] ?? false,
        isBookmarked: json['is_bookmarked'] ?? 0,
        postType: json['post_type'] ?? 1,
        postMedia: json['post_media'] != null
            ? List<PostMedia>.from(
                json['post_media'].map((x) => PostMedia.fromJson(x)))
            : [],
        totalLikes: json['total_likes'],
        totalComments: json['total_comments']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_created_by': postCreatedBy,
      'post_created_by_username': postCreatedByUsername,
      'post_created_by_user_icon': postCreatedByUserIcon,
      'post_created_at': postCreatedAt.toIso8601String(),
      'post_caption': postCaption,
      'liked_by_current_user': likedByCurrentUser,
      'post_type': postType,
      'post_media': postMedia.map((x) => x.toJson()).toList(),
      'total_comments': totalComments,
      'total_likes': totalLikes,
    };
  }

  @override
  String toString() {
    return 'Posts(id: $id, postCreatedBy: $postCreatedBy, postCaption: $postCaption, ...)'; // Add other fields as needed
  }
}

class Comment {
  int id;
  String comment;
  int commentBy;
  String commentByUsername;
  String? commentatorProfileImage;
  int isParent;
  int parentId;
  int isAvailable;
  DateTime createdAt;

  Comment({
    required this.id,
    required this.comment,
    required this.commentBy,
    required this.commentByUsername,
    this.commentatorProfileImage,
    required this.isParent,
    required this.parentId,
    required this.isAvailable,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      comment: json['comment'] ?? "",
      commentBy: json['comment_by'] ?? 0,
      commentByUsername: json['comment_by_username'] ?? "",
      commentatorProfileImage: json['commentator_profile_image'] ?? "",
      isParent: json['is_parent'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      isAvailable: json['is_available'] ?? 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime(2017, 9, 7, 17, 30),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'comment_by': commentBy,
      'comment_by_username': commentByUsername,
      'commentator_profile_image': commentatorProfileImage,
      'is_parent': isParent,
      'parent_id': parentId,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Like {
  int id;
  int postId;
  int likedBy;
  String likedByUsername;
  DateTime createdAt;

  Like({
    required this.id,
    required this.postId,
    required this.likedBy,
    required this.likedByUsername,
    required this.createdAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'] ?? 1,
      postId: json['post_id'] ?? 0,
      likedBy: json['liked_by'] ?? 0,
      likedByUsername: json['liked_by_username'] ?? "",
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime(2017, 9, 7, 17, 30),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'liked_by': likedBy,
      'liked_by_username': likedByUsername,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class PostMedia {
  String mediaName;
  int mediaType;
  int mediaPosition;
  String? path;

  PostMedia(
      {required this.mediaName,
      required this.mediaType,
      required this.mediaPosition,
      this.path});

  factory PostMedia.fromJson(Map<String, dynamic> json) {
    return PostMedia(
      mediaName: json['media_name'],
      mediaType: json['media_type'] ?? 1,
      mediaPosition:
          json['media_position'] != null ? json['media_position'] : 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'media_name': mediaName,
      'media_type': mediaType,
      'media_position': mediaPosition,
    };
  }
}
