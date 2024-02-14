import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/userpostscontroller.dart';
import 'package:univ_app/models/user.dart';
import 'package:univ_app/utility/values.dart';

class UserPostsGallery extends StatelessWidget {
  UserPostsController userPostsController =
      Get.put(UserPostsController(postType: 1));

  @override
  Widget build(BuildContext context) {
    return GetX<UserPostsController>(
      builder: (logic) {
        return SliverGrid(
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
                              child:
                                  CircularProgressIndicator(strokeWidth: 3.0),
                            ),
                            // Placeholder widget
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error), // Error widget
                          )),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: IconButton(
                            onPressed: () {
                              logic.deletePost(logic.userPosts[index].id);
                            },
                            icon: const Icon(
                              FontAwesomeIcons.ellipsisVertical,
                              size: 20,
                              color: Colors.white,
                            )),
                      ),
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
}
