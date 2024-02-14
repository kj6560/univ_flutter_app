import 'dart:ffi';

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

import '../../controllers/postdetailcontroller.dart';

class PostDetail extends StatefulWidget {
  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail>
    with SingleTickerProviderStateMixin {
  final PostDetailController controller = Get.put(PostDetailController());
  final commentsController = Get.put(CommentsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: const EdgeInsets.only(bottom: 100),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 0, top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          '${Values.profilePic}${controller.postCreatedByUserIcon.value}',
                        ),
                      ),
                      title: Text(
                        controller.postCreatedByUsername.value,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        DateFormat('yyyy-MM-dd')
                            .format(controller.postCreatedAt.value),
                      ),
                    ),
                    onTap: () {
                      controller.userGoingToSocialProfile(
                          controller.postCreatedBy.value, context);
                    },
                  ),
                  if (controller.postMedia.value.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 350,
                          child: PageView.builder(
                            itemCount: controller.postMedia.value.length,
                            itemBuilder: (context, mediaIndex) {
                              return AspectRatio(
                                aspectRatio: 4 / 3,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${Values.postMediaUrl}${controller.postMedia.value[mediaIndex].mediaName}',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              );
                            },
                            onPageChanged: (index) {},
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: controller.likedByCurrentUser.value
                                    ? Icon(
                                        FontAwesomeIcons.solidHeart,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        FontAwesomeIcons.heart,
                                        color: Colors.red,
                                      ),
                              ),
                              onTap: () {
                                if (controller.likedByCurrentUser.value) {
                                  controller.totalLikes.value =
                                      controller.totalLikes.value - 1;
                                  controller.processLikes(
                                      controller.id.value, false);
                                } else {
                                  controller.totalLikes.value =
                                      controller.totalLikes.value + 1;
                                  controller.processLikes(
                                      controller.id.value, true);
                                }
                              },
                            ),
                            InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(FontAwesomeIcons.comment),
                              ),
                              onTap: () {
                                showCommentModel(
                                    controller.id.value, context);
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(FontAwesomeIcons.paperPlane),
                            ),
                          ],
                        ),
                        controller.postCreatedBy.value !=
                                controller.current_user_id.value
                            ? InkWell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: controller.isBookmarked.value != 1
                                      ? Icon(FontAwesomeIcons.bookmark)
                                      : Icon(
                                          FontAwesomeIcons.solidBookmark,
                                          color: Colors.red,
                                        ),
                                ),
                                onTap: () async {
                                  if (controller.isBookmarked.value != 1) {
                                    if (await controller
                                        .bookmarkPost(controller.id.value)) {
                                    } else {}
                                  } else {
                                    if (await controller
                                        .unBookmarkPost(controller.id.value)) {
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
                            Text("${controller.totalLikes.value} likes")
                          ],
                        ),
                        Row(
                          children: [
                            Text("${controller.totalComments.value} comments")
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "${controller.postCaption.value}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void showCommentModel(int post_id, BuildContext context) {
    if (commentsController.comments.length > 0) {
      commentsController.comments.clear();
    }
    commentsController.setPostId(post_id);
    commentsController.fetchComments();
    final commentTextController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext builder) {
        double screenHeight = MediaQuery.of(context).size.height;

        return Container(
          height: screenHeight * 0.75,
          child: Column(
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
                        "Comments(${controller.totalComments.value})",
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
                          var commentAdded =
                              await commentsController.postComment(commentText);
                          if (commentAdded) {
                            commentTextController.clear();
                            controller.posts
                                .singleWhere((element) => element.id == post_id)
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
        );
      },
    );
  }
}
