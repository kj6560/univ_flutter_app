import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/socialprofilecontroller.dart';
import 'package:univ_app/controllers/userpostscontroller.dart';
import 'package:univ_app/models/user.dart';
import 'package:univ_app/utility/values.dart';

class UserPostsGallery extends StatelessWidget {
  UserPostsController userPostsController =
      Get.put(UserPostsController(postType: 1));
  SocialProfileController socialProfileController;
  bool isCurrentUser;

  UserPostsGallery(
      {required this.socialProfileController, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return GetX<UserPostsController>(
      builder: (logic) {
        return logic.userPosts.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                    child: Text(
                  "Yet To Upload A Post",
                  style: TextStyle(color: Values.primaryColor, fontSize: 16),
                )),
              )
            : SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.grey,
                            child: InkWell(
                                onTap: () {
                                  Get.toNamed("/post_detail", arguments: {
                                    "post_id": logic.userPosts[index].id,
                                    "post_type": logic.userPosts[index].postType
                                  });
                                },
                                child: CachedNetworkImage(
                                  height: 150,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${Values.postMediaUrl}${logic.userPosts[index].postMedia}",
                                  // URL of the image
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 3.0),
                                  ),
                                  // Placeholder widget
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error), // Error widget
                                )),
                          ),
                          this.isCurrentUser
                              ? Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: IconButton(
                                        onPressed: () {
                                          showPostModal(
                                              logic.userPosts[index].id,
                                              context,
                                              logic);
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
      int post_id, BuildContext context, UserPostsController logic) {
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
                  child: const Text("Post Options",
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
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: const Center(
                    child: Text(
                      "Archive Post",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ]),
        );
      },
    );
  }
}
