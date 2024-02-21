import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';

import '../utility/values.dart';

class CommentsController extends GetxController {
  var comments = List<Comment>.empty().obs;
  var post_id = 0.obs;
  var total_comments = 0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var arguments = Get.arguments;
    post_id.value = arguments != null ?arguments["post_id"]:0;
    fetchComments();
  }

  Future<List<Comment>> fetchComments({post__id=0}) async {
    if(post__id !=0){
      post_id.value = post__id;
    }
    print("post id inside post detail: ${post_id.value}");
    var response = await RemoteServices.fetchComments(post_id.value);
    List<Comment> commentsRecieved = commentFromJson(response);
    for (var comment in commentsRecieved) {
      Values.cacheFile(
          "${Values.profilePic}${comment.commentatorProfileImage}");
    }
    total_comments.value = commentsRecieved.length;
    print("Total comments: ${total_comments.value}");
    return comments.value = commentsRecieved;
  }

  Future<bool> postComment(var comment) async {
    var response = await RemoteServices.postComment(post_id.value, comment);
    //print(response);
    if (response['success']) {
      var commentReceived = response['comment'];
      if (commentReceived != null) {
        if (commentReceived['commentator_profile_image'] != null) {
          Values.cacheFile(
              "${Values.profilePic}${commentReceived['commentator_profile_image']}");
        }
        comments.add(Comment(
          id: commentReceived['id'] ?? 0,
          comment: commentReceived['comment'] ?? "",
          commentBy: commentReceived['comment_by'] ?? 0,
          commentByUsername: commentReceived['comment_by_username'] ?? "",
          commentatorProfileImage: commentReceived['commentator_profile_image'],
          isParent: commentReceived['is_parent'] ?? 0,
          parentId: commentReceived['parent_id'] ?? 1,
          isAvailable: commentReceived['is_available'] ?? 1,
          createdAt: commentReceived['created_at'] != null
              ? DateTime.parse(commentReceived['created_at'])
              : DateTime(2017, 9, 7, 17, 30),
        ));
        total_comments.value = total_comments.value + 1;
        comments.refresh();
        total_comments.refresh();
        return true;
      }
    } else {
      return false;
    }
    return false;
  }

  void setPostId(int postId) {
    post_id.value = postId;
  }
}
