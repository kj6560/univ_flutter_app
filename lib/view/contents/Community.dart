import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/controllers/communitycontroller.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/utility/values.dart';

class Community extends StatefulWidget {
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community>
    with SingleTickerProviderStateMixin {
  final CommunityController controller = Get.put(CommunityController());
  int? current_user_id = 0;
  late PageController _pageController;
  double _currentPage = 0; // Initialize Dots PageController

  @override
  void initState() {
    super.initState();
    setCurrentUser();
    // _pageController = PageController();
    // _pageController.addListener(() {
    //   setState(() {
    //     _currentPage = _pageController.page!;
    //   });
    //   print("current page: ${_currentPage}");
    // });
  }

  setCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      current_user_id = prefs.getInt("id")!;
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the Dots PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<CommunityController>(builder: (logic) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Community",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.offAllNamed("/messenger", arguments: current_user_id);
                    },
                    icon: const Icon(
                      FontAwesomeIcons.facebookMessenger,
                      size: 25,
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Posts post = logic.posts[index];
                List<Like> likes = logic.posts[index].likes;

                return Container(
                  margin: const EdgeInsets.only(bottom: 3),
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
                                '${Values.profilePic}${post.postCreatedByUserIcon}',
                              ),
                            ),
                            title: Text(
                              post.postCreatedByUsername,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(post.postCreatedAt),
                            ),
                          ),
                          onTap: () {
                            logic.userGoingToSocialProfile(
                                post.postCreatedBy, context);
                          },
                        ),

                        // Display all media items
                        if (post.postMedia.isNotEmpty)
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 350,
                                child: PageView.builder(
                                  itemCount: post.postMedia.length,
                                  itemBuilder: (context, mediaIndex) {
                                    return AspectRatio(
                                      aspectRatio: 4 / 3,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${Values.postMediaUrl}${post.postMedia[mediaIndex].mediaName}',
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    );
                                  },
                                  onPageChanged: (index) {

                                  },
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(FontAwesomeIcons.heart),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(FontAwesomeIcons.comment),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(FontAwesomeIcons.paperPlane),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(FontAwesomeIcons.bookmark),
                              )
                            ],
                          ),
                        ),

                        // Display Comments
                        if (post.comments.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text:
                                        '@${post.comments[0].commentByUsername} ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: '${post.comments[0].comment}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (likes.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: likes.length > 0
                                        ? '@${likes.first.likedByUsername}'
                                        : '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: likes.length > 1
                                        ? ' and ${likes.length - 1} others liked it'
                                        : likes.length == 1
                                            ? ' liked it'
                                            : '',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            post.postCaption,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: logic.posts.length,
            ),
          ),
        ],
      );
    });
  }
}
