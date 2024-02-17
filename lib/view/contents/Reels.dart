import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:univ_app/controllers/reelscontroller.dart';
import 'package:univ_app/view/pages/mycommunity.dart';

import '../../controllers/commentscontroller.dart';
import '../../utility/values.dart';
import 'VideoPlayerScreen.dart';

class Reels extends StatelessWidget {
  Reels({super.key});

  final ReelsController controller = Get.put(ReelsController());
  final commentsController = Get.put(CommentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.posts.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: VideoPlayerScreen(
                                videoUrl:
                                    "${Values.postMediaUrl}${controller.posts[index].postMedia[0].mediaName}"),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: InkWell(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Get.offAll(() => MyCommunity(),
                                      transition: Transition.rightToLeft);
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            right: 0,
                            child: Column(
                              children: [
                                Column(children: [
                                  //likes
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          child: controller.posts[index]
                                                  .likedByCurrentUser
                                              ? const Icon(
                                                  FontAwesomeIcons.solidHeart,
                                                  color: Colors.red,
                                                  size: 25,
                                                )
                                              : const Icon(
                                                  FontAwesomeIcons.heart,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                          onTap: () {
                                            if (controller.posts[index]
                                                .likedByCurrentUser) {
                                              controller.posts[index]
                                                  .totalLikes = controller
                                                      .posts[index].totalLikes -
                                                  1;
                                              controller.processLikes(
                                                  controller.posts[index].id,
                                                  false);
                                            } else {
                                              controller.posts[index]
                                                  .totalLikes = controller
                                                      .posts[index].totalLikes +
                                                  1;
                                              controller.processLikes(
                                                  controller.posts[index].id,
                                                  true);
                                            }
                                          },
                                        ),
                                        Text(
                                          "${controller.posts[index].totalLikes}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //comment
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [

                                        InkWell(
                                          child: const Icon(
                                            FontAwesomeIcons.comment,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          onTap: () {
                                            showCommentWindow(
                                                controller.posts[index].id,
                                                context);
                                          },
                                        ),
                                        Text(
                                            "${controller.posts[index].totalComments}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),

                                  //share
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.paperPlane,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      ],
                                    ),
                                  ),

                                  //bookmark
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        controller.posts[index].postCreatedBy !=
                                                controller.current_user_id.value
                                            ? InkWell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: controller.posts[index]
                                                              .isBookmarked !=
                                                          1
                                                      ? const Icon(
                                                          FontAwesomeIcons
                                                              .bookmark,
                                                          color: Colors.white,
                                                        )
                                                      : const Icon(
                                                          FontAwesomeIcons
                                                              .solidBookmark,
                                                          color: Colors.red,
                                                        ),
                                                ),
                                                onTap: () async {
                                                  if (controller.posts[index]
                                                          .isBookmarked !=
                                                      1) {
                                                    if (await controller
                                                        .bookmarkPost(controller
                                                            .posts[index].id)) {
                                                    } else {}
                                                  } else {
                                                    if (await controller
                                                        .unBookmarkPost(
                                                            controller
                                                                .posts[index]
                                                                .id)) {
                                                    } else {}
                                                  }
                                                },
                                              )
                                            : const SizedBox(
                                                height: 1,
                                              )
                                      ],
                                    ),
                                  ),

                                  //reel options
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          FontAwesomeIcons.ellipsisVertical,
                                          size: 25,
                                          color: Colors.white,
                                        )),
                                  )
                                ]),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Positioned(
                              bottom: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Wrap(
                                  direction: Axis.vertical,
                                  children: [
                                    Text(
                                      controller.posts[index].postCaption,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ));
                },
              ),
            ),
          ],
        ));
  }

  void showCommentWindow(int post_id, var context) {
    if (commentsController.comments.length > 0) {
      commentsController.comments.clear();
    }
    commentsController.setPostId(post_id);
    commentsController.fetchComments();
    final commentTextController = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Comments(${controller.posts.singleWhere((element) => element.id == post_id).totalComments})",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: Values.primaryColor,
                  ),
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: commentsController.comments.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: CircleAvatar(
                              child: Image.network(
                                "${Values.profilePic}${commentsController.comments[index].commentatorProfileImage}",
                              ),
                            ),
                            title: Text(
                              "${commentsController.comments[index].commentByUsername}",
                            ),
                            subtitle: Text(
                              "${commentsController.comments[index].comment}",
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(38.0),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentTextController,
                              obscureText: false,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                              decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xff000000),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xff000000),
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xff000000),
                                    width: 1,
                                  ),
                                ),
                                hintText: "write comment",
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff494646),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                isDense: false,
                                contentPadding: const EdgeInsets.all(0),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              String commentText = commentTextController.text;
                              var commentAdded = await commentsController
                                  .postComment(commentText);
                              if (commentAdded) {
                                commentTextController.clear();
                                controller.posts
                                    .singleWhere(
                                        (element) => element.id == post_id)
                                    .totalComments += 1;
                                controller.posts.refresh();
                              }
                            },
                            child: Text("post"),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
