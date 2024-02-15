import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/uservideoscontroller.dart';
import 'package:univ_app/utility/values.dart';

import '../../controllers/socialprofilecontroller.dart';
import 'ProfileVideoPlayerScreen.dart';

class UserReelsGallery extends StatelessWidget {
  UserVideosController userReelsController =
      Get.put(UserVideosController(postType: 2));

  SocialProfileController socialProfileController;
  bool isCurrentUser;

  UserReelsGallery(
      {required this.socialProfileController, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return GetX<UserVideosController>(
      builder: (logic) {
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          delegate: SliverChildBuilderDelegate(
            addRepaintBoundaries: true,
            (BuildContext context, int index) {
              final videoUrl =
                  Values.postMediaUrl + logic.userPosts[index].postMedia;
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey,
                      child: InkWell(
                        child: ProfileVideoPlayerScreen(videoUrl: videoUrl),
                        onTap: () {
                          Get.offAllNamed("/reels",
                              arguments: logic.userPosts[index].id);
                        },
                      ),
                    ),
                    this.isCurrentUser
                        ? Positioned(
                            right: 0,
                            top: 0,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: IconButton(
                                  onPressed: () {
                                    showPostModal(logic.userPosts[index].id,
                                        context, logic);
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.ellipsisVertical,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                            ),
                          )
                        : SizedBox(
                            height: 1,
                          )
                  ],
                ),
              );
            },
            childCount: logic.userPosts.length,
          ),
        );
      },
    );
  }

  void showPostModal(
      int post_id, BuildContext context, UserVideosController logic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext builder) {
        return FractionallySizedBox(
          heightFactor: 0.3,
          child: Column(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.circleXmark,
                      size: 30,
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text("Reels Options",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const Divider(
              height: 2,
              thickness: 2,
              color: Values.primaryColor,
            ),
            InkWell(
              onTap: () {
                logic.deletePost(post_id);
                logic.userPosts.refresh();
                socialProfileController.posts =
                    socialProfileController.posts - 1;
                socialProfileController.refresh();
                Navigator.of(context).pop();
              },
              child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Archive Reel",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )),
            ),
          ]),
        );
      },
    );
  }
}
