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

  static void createPost(List<PostMedia> mediaFiles, String caption,
      int post_type, var context) async {
    var post_id =
        await RemoteServices.createPost(mediaFiles, caption, post_type);
    print("created post id: $post_id");
    if (post_id != 0) {
      print("Total files to upload: ${mediaFiles.length}");
      var media_uploaded =
          await RemoteServices.uploadPostMedia(mediaFiles, post_type, post_id);
      if (media_uploaded) {
        Values.showMsgDialog(
            "New Post", "You have successfully created a new post!!", context,
            () {
          Navigator.of(context).pop();
          Get.offAllNamed("/community");
        });
      } else {
        var post_deleted = await RemoteServices.deletePost(post_type);
        if (post_deleted) {
          Values.showMsgDialog(
              "New Post",
              "Media type not supported or some other error occured while uploading media!!",
              context, () {
            Navigator.of(context).pop();
          });
        }
      }
    }
  }
}
