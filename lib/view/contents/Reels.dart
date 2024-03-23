import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:univ_app/controllers/reelscontroller.dart';
import 'package:univ_app/view/pages/mycommunity.dart';

import '../../controllers/commentscontroller.dart';
import '../../utility/values.dart';
import '../../services/video_player.dart';

class Reels extends StatefulWidget {
  const Reels({super.key, required this.index});

  final int index;

  @override
  State<Reels> createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  final ReelsController controller = Get.put(ReelsController());
  final commentsController = Get.put(CommentsController());
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
    print("disposing reels");
  }

  void disposeGetController() async {
    if (await Get.delete<ReelsController>()) {
      print("delete reels controller");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Expanded(
              child: controller.posts.length > 0
                  ? PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _pageController,
                      itemCount: controller.posts.length,
                      onPageChanged: (index) {
                        currentPage = index;
                      },
                      itemBuilder: (context, index) {
                        return controller.posts.length > 0
                            ? Stack(
                                children: [
                                  VideoPlayerWidget(
                                    key: Key(
                                        "${Values.postMediaUrl}${controller.posts[index].postMedia[0].mediaName}"),
                                    reelUrl:
                                        "${Values.postMediaUrl}${controller.posts[index].postMedia[0].mediaName}",
                                  ),
                                  Positioned(
                                    top: 25,
                                    left: 10,
                                    child: InkWell(
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Get.toNamed(
                                            "/community",
                                          );
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
                                                          FontAwesomeIcons
                                                              .solidHeart,
                                                          color: Colors.red,
                                                          size: 25,
                                                        )
                                                      : const Icon(
                                                          FontAwesomeIcons
                                                              .heart,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ),
                                                  onTap: () {
                                                    if (controller.posts[index]
                                                        .likedByCurrentUser) {
                                                      controller.posts[index]
                                                              .totalLikes =
                                                          controller
                                                                  .posts[index]
                                                                  .totalLikes -
                                                              1;
                                                      controller.processLikes(
                                                          controller
                                                              .posts[index].id,
                                                          false);
                                                    } else {
                                                      controller.posts[index]
                                                              .totalLikes =
                                                          controller
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
                                                        controller
                                                            .posts[index].id,
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
                                                controller.posts[index]
                                                            .postCreatedBy !=
                                                        controller
                                                            .current_user_id
                                                            .value
                                                    ? InkWell(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: controller
                                                                      .posts[
                                                                          index]
                                                                      .isBookmarked !=
                                                                  1
                                                              ? const Icon(
                                                                  FontAwesomeIcons
                                                                      .bookmark,
                                                                  color: Colors
                                                                      .white,
                                                                )
                                                              : const Icon(
                                                                  FontAwesomeIcons
                                                                      .solidBookmark,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                        ),
                                                        onTap: () async {
                                                          if (controller
                                                                  .posts[index]
                                                                  .isBookmarked !=
                                                              1) {
                                                            if (await controller
                                                                .bookmarkPost(
                                                                    controller
                                                                        .posts[
                                                                            index]
                                                                        .id)) {
                                                            } else {}
                                                          } else {
                                                            if (await controller
                                                                .unBookmarkPost(
                                                                    controller
                                                                        .posts[
                                                                            index]
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
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  FontAwesomeIcons
                                                      .ellipsisVertical,
                                                  size: 20,
                                                  color: Colors.white,
                                                )),
                                          )
                                        ]),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 60,
                                    left: 2,
                                    child: InkWell(
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              '${Values.profilePic}${controller.posts[index].postCreatedByUserIcon}',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  controller.posts[index]
                                                      .postCreatedByUsername,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  DateFormat('dd MMM yyyy')
                                                      .format(controller
                                                          .posts[index]
                                                          .postCreatedAt),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        controller.userGoingToSocialProfile(
                                            controller
                                                .posts[index].postCreatedBy,
                                            context);
                                      },
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 30,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 15, 0.0, 0.0),
                                        child: Text(
                                          controller.posts[index].postCaption,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ))
                                ],
                              )
                            : Container(
                                child: Center(
                                  child: Text("No Reels Available"),
                                ),
                              );
                      },
                    )
                  : Container(
                      child: Center(
                        child: Text(
                          "Be the first one to create a Reel",
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
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
