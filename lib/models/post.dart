import 'dart:convert';
List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

class Posts {
  List<Post> posts;
  Posts({
    required this.posts,

  });
}

class Post {
  int id;
  int postCreatedBy;
  DateTime postCreatedAt;
  String postCaption;
  int postType;
  List<PostMedia> postMedia;
  List<Comment> comments;
  List<Like> likes;

  Post({
    required this.id,
    required this.postCreatedBy,
    required this.postCreatedAt,
    required this.postCaption,
    required this.postType,
    required this.postMedia,
    required this.comments,
    required this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<PostMedia> parsePostMedia(dynamic mediaList) {
      if (mediaList == null || !(mediaList is List)) {
        return []; // Return an empty list if mediaList is null or not a list
      }

      return List<PostMedia>.from(mediaList.map((media) {
        return PostMedia(
          mediaName: media['mediaName'] ?? '', // Use empty string if mediaName is null
          mediaType: media['mediaType'] ?? 0, // Use 0 or another default value for mediaType
          mediaPosition: media['mediaPosition'] ?? 0, // Use 0 or another default value for mediaPosition
        );
      }));
    }


    List<Comment> parseComments(dynamic commentsList) {
      return List<Comment>.from(commentsList.map((comment) {
        return Comment(
          id: comment['id'],
          comment: comment['comment'],
          commentBy: comment['commentBy'],
          isParent: comment['isParent'],
          parentId: comment['parentId'],
          isAvailable: comment['isAvailable'],
          createdAt: DateTime.parse(comment['createdAt']),
        );
      }));
    }

    List<Like> parseLikes(dynamic likesList) {
      return List<Like>.from(likesList.map((like) {
        return Like(
          id: like['id'],
          likedBy: like['likedBy'],
          createdAt: DateTime.parse(like['createdAt']),
        );
      }));
    }

    return Post(
      id: json['id'],
      postCreatedBy: json['postCreatedBy'] ?? 0,
      postCreatedAt: json['postCreatedAt']  !=null?DateTime.parse(json['postCreatedAt']):DateTime(2023),
      postCaption: json['postCaption'] !=null ? json['postCaption'] :"",
      postType: json['postType'] !=null?json['postType']:0,
      postMedia: json['postMedia']?? parsePostMedia(json['postMedia']),
      comments: json['comments'] !=null ? parseComments(json['comments']):List<Comment>.empty(),
      likes: json['likes'] ?? parseLikes(json['likes']),
    );
  }
}

class Comment {
  int id;
  String comment;
  int commentBy;
  int isParent;
  int parentId;
  int isAvailable;
  DateTime createdAt;

  Comment({
    required this.id,
    required this.comment,
    required this.commentBy,
    required this.isParent,
    required this.parentId,
    required this.isAvailable,
    required this.createdAt,
  });
}

class Like {
  int id;
  int likedBy;
  DateTime createdAt;

  Like({
    required this.id,
    required this.likedBy,
    required this.createdAt,
  });
}

class PostMedia {
  String mediaName;
  int mediaType;
  int mediaPosition;

  PostMedia({
    required this.mediaName,
    required this.mediaType,
    required this.mediaPosition,
  });
}
