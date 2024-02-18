import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';

import '../utility/values.dart';

class PostController extends GetxController {


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  static Future<bool> createPost(List<PostMedia> mediaFiles, String caption,
      int post_type, var context) async {
    var post_id =
        await RemoteServices.createPost(mediaFiles, caption, post_type);

    if (post_id != 0) {
      if (post_type == 1) {
        var media_uploaded = await RemoteServices.uploadPostMedia(
            mediaFiles, post_type, post_id);
        statusCheck(media_uploaded, context, post_id);
      } else {
        var media_uploaded =
            await RemoteServices.uploadVideoFile(post_id, mediaFiles[0].path!);
        statusCheck(media_uploaded, context, post_id);
      }
    }
    return true;
  }

  static statusCheck(var uploadResponse, var context, int post_id) async {
    if (uploadResponse["success"]) {
      Values.showMsgDialog(
          "New Post", "You have successfully created a new post!!", context,
          () {
        Navigator.of(context).pop();
        Get.offAllNamed("/community");
      });
    } else {
      var post_deleted = await RemoteServices.deletePost(post_id,permanently: true);
      if (post_deleted) {
        Values.showMsgDialog(
            "New Post",
            uploadResponse["message"],
            context, () {
          Navigator.of(context).pop();
        });
      }
    }
  }
}
