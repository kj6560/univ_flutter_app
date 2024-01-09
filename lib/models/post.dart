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
  String postCreatedByUsername;
  DateTime postCreatedAt;
  String postCaption;
  int postType;
  List<PostMedia> postMedia;
  List<Comment> comments;
  List<Like> likes;

  Post({
    required this.id,
    required this.postCreatedBy,
    required this.postCreatedByUsername,
    required this.postCreatedAt,
    required this.postCaption,
    required this.postType,
    required this.postMedia,
    required this.comments,
    required this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<PostMedia> parsePostMedia(dynamic mediaList) {
      if (mediaList == null || mediaList.isEmpty || !(mediaList is List)) {
        return []; // Return an empty list if mediaList is null or not a list
      }

      return List<PostMedia>.from(mediaList.map((media) {
        return PostMedia(
          mediaName: media['media_name'] ?? '',
          mediaType: media['media_type'] ?? 0,
          mediaPosition: media['media_position'] ?? 0,
        );
      }));
    }

    List<Comment> parseComments(dynamic commentsList) {
      if (commentsList == null ||
          commentsList.isEmpty ||
          !(commentsList is List)) {
        return []; // Return an empty list if commentsList is null or not a list
      }

      return List<Comment>.from(commentsList.map((comment) {
        return Comment(
          id: comment['id'] ?? 0,
          comment: comment['comment'] ?? '',
          commentBy: comment['comment_by'] ?? '',
          commentById: comment['comment_by_id'] ?? 0,
          isParent: comment['is_parent'] ?? 0,
          parentId: comment['parent_id'] ?? 0,
          isAvailable: comment['is_available'] ?? 0,
          createdAt: comment['created_at'] != null
              ? DateTime.parse(comment['created_at'])
              : DateTime(2023),
        );
      }));
    }

    List<Like> parseLikes(dynamic likesList) {
      if (likesList == null || likesList.isEmpty || !(likesList is List)) {
        return []; // Return an empty list if likesList is null or not a list
      }

      return List<Like>.from(likesList.map((like) {
        return Like(
          id: like['id'] ?? 0,
          likedBy: like['liked_by'] ,
          createdAt: like['created_at'] != null
              ? DateTime.parse(like['created_at'])
              : DateTime(2023),
        );
      }));
    }

    return Post(
      id: json['id'] ?? 0,
      postCreatedBy: json['post_created_by'] ?? 0,
      postCreatedByUsername: json['post_created_by_username'] as String? ?? '',
      postCreatedAt: json['post_created_at'] != null
          ? DateTime.parse(json['post_created_at'])
          : DateTime(2023),
      postCaption: json['post_caption'] ?? '',
      postType: json['post_type'] ?? 0,
      postMedia: parsePostMedia(json['post_media']),
      comments: parseComments(json['comments']),
      likes: parseLikes(json['likes']),
    );
  }
}

class Comment {
  int id;
  String comment;
  String commentBy;
  int commentById;
  int isParent;
  int parentId;
  int isAvailable;
  DateTime createdAt;

  Comment({
    required this.id,
    required this.comment,
    required this.commentBy,
    required this.commentById,
    required this.isParent,
    required this.parentId,
    required this.isAvailable,
    required this.createdAt,
  });
}

class Like {
  int id;
  String likedBy;
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
