import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/userpostscontroller.dart';
import 'package:univ_app/controllers/uservideoscontroller.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';
import 'package:video_player/video_player.dart';

import 'VideoPlayerScreen.dart';

class UserReelsGallery extends StatelessWidget {
  UserVideosController userReelsController = Get.put(UserVideosController(postType: 2));

  @override
  Widget build(BuildContext context) {
    return GetX<UserVideosController>(
      builder: (logic) {
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust the number of columns as needed
          ),
          delegate: SliverChildBuilderDelegate(
            addRepaintBoundaries: true,
                (BuildContext context, int index) {
              final videoUrl =
                  Values.postMediaUrl + logic.userPosts[index].postMedia;
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  color: Colors.grey,
                  child: VideoPlayerScreen(videoUrl: videoUrl),
                ),
              );
            },
            childCount: logic.userPosts.length,
          ),
        );
      },
    );
  }
}



