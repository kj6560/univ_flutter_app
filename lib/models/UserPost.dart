// To parse this JSON data, do
//
//     final userPost = userPostFromJson(jsonString);

import 'dart:convert';

List<UserPost> userPostFromJson(String str) => List<UserPost>.from(json.decode(str).map((x) => UserPost.fromJson(x)));

String userPostToJson(List<UserPost> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserPost {
  int id;
  int postType;
  int isBookmarked;
  String postMedia;

  UserPost({
    required this.id,
    required this.postType,
    required this.isBookmarked,
    required this.postMedia,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
    id: json["id"],
    postType: json["post_type"],
    isBookmarked: json["is_bookmarked"],
    postMedia: json["post_media"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "post_type": postType,
    "is_bookmarked": isBookmarked,
    "post_media": postMedia,
  };
}
