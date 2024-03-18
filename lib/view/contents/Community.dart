import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/controllers/commentscontroller.dart';
import 'package:univ_app/controllers/communitycontroller.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/utility/values.dart';
import 'package:univ_app/view/contents/VideoPlayerScreen.dart';

class Community extends StatelessWidget {
  final CommunityController controller = Get.put(CommunityController());
  final commentsController = Get.put(CommentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Expanded(
              child: controller.posts.length > 0
                  ? ListView.builder(
                      itemCount: controller.posts.length,
                      // Specify the number of items in the list
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 3),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 1,
                              margin: const EdgeInsets.only(bottom: 0, top: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      (controller.posts[index].postMedia
                                                  .isNotEmpty &&
                                              controller
                                                      .posts[index].postType ==
                                                  1)
                                          ? Column(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 350,
                                                  child: PageView.builder(
                                                    itemCount: controller
                                                        .posts[index]
                                                        .postMedia
                                                        .length,
                                                    itemBuilder:
                                                        (context, mediaIndex) {
                                                      return AspectRatio(
                                                        aspectRatio: 4 / 3,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              '${Values.postMediaUrl}${controller.posts[index].postMedia[mediaIndex].mediaName}',
                                                          fit: BoxFit.cover,
                                                          alignment:
                                                              Alignment.center,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      );
                                                    },
                                                    onPageChanged: (index) {},
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              height: 300,
                                              width: 480,
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  InkWell(
                                                    child: VideoPlayerScreen(
                                                        videoUrl:
                                                            "${Values.postMediaUrl}${controller.posts[index].postMedia[0].mediaName}"),
                                                    onDoubleTap: () {
                                                      Get.toNamed("/reels",
                                                          arguments: {
                                                            "post_id":
                                                                controller
                                                                    .posts[
                                                                        index]
                                                                    .id,
                                                            "index": index
                                                          });
                                                    },
                                                  ),
                                                  // Positioned(
                                                  //   bottom: 2,
                                                  //   right: 2,
                                                  //   child: ElevatedButton(
                                                  //       onPressed: () {
                                                  //         Get.offAllNamed("/reels",
                                                  //             arguments: {"post_id":controller
                                                  //                 .posts[index].id,"index":index});
                                                  //       },
                                                  //       child: Text("Open In Reels")),
                                                  // )
                                                ],
                                              ),
                                            ),
                                      InkWell(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              '${Values.profilePic}${controller.posts[index].postCreatedByUserIcon}',
                                            ),
                                          ),
                                          title: Text(
                                            controller.posts[index]
                                                .postCreatedByUsername,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            DateFormat('dd MMM yyyy').format(
                                                controller.posts[index]
                                                    .postCreatedAt),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        onTap: () {
                                          controller.userGoingToSocialProfile(
                                              controller
                                                  .posts[index].postCreatedBy,
                                              context);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: controller.posts[index]
                                                        .likedByCurrentUser
                                                    ? Icon(
                                                        FontAwesomeIcons
                                                            .solidHeart,
                                                        color: Colors.red,
                                                      )
                                                    : Icon(
                                                        FontAwesomeIcons.heart,
                                                        color: Colors.red,
                                                      ),
                                              ),
                                              onTap: () {
                                                if (controller.posts[index]
                                                    .likedByCurrentUser) {
                                                  controller.posts[index]
                                                      .totalLikes = controller
                                                          .posts[index]
                                                          .totalLikes -
                                                      1;
                                                  controller.processLikes(
                                                      controller
                                                          .posts[index].id,
                                                      false);
                                                } else {
                                                  controller.posts[index]
                                                      .totalLikes = controller
                                                          .posts[index]
                                                          .totalLikes +
                                                      1;
                                                  controller.processLikes(
                                                      controller
                                                          .posts[index].id,
                                                      true);
                                                }
                                              },
                                            ),
                                            InkWell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                    FontAwesomeIcons.comment),
                                              ),
                                              onTap: () {
                                                // showCommentModel(
                                                //     controller.posts[index].id,
                                                //     context);
                                                showCommentWindow(
                                                    controller.posts[index].id,
                                                    context);
                                              },
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                  FontAwesomeIcons.paperPlane),
                                            ),
                                          ],
                                        ),
                                        controller.posts[index].postCreatedBy !=
                                                controller.current_user_id.value
                                            ? InkWell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: controller.posts[index]
                                                              .isBookmarked !=
                                                          1
                                                      ? Icon(FontAwesomeIcons
                                                          .bookmark)
                                                      : Icon(
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
                                            : SizedBox(
                                                height: 1,
                                              )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                "${controller.posts[index].totalLikes} likes")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                "${controller.posts[index].totalComments} comments")
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "${controller.posts[index].postCaption}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      child: Center(
                        child: Text(
                          "Be the first one to create a post",
                          style: TextStyle(
                              fontSize: 16,
                              color: Values.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                child: SizedBox(
                                  height: 5,
                                  width: 100,
                                ),
                              ),
                            ),
                          ],
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
