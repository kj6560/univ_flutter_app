import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<CommunityController>(builder: (logic) {
      return ListView.builder(
        itemCount: logic.posts.length,
        itemBuilder: (context, index) {
          Posts post = logic.posts[index];
          List<Like> likes = logic.posts[index].likes;
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 0, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          '${Values.profilePic}${post.postCreatedByUserIcon}'),
                    ),
                    title: Text(
                      post.postCreatedByUsername,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat('yyyy-MM-dd').format(post.postCreatedAt),
                    ),
                  ),
                  onTap: () {
                    logic.userGoingToSocialProfile(post.postCreatedBy);
                  },
                ),

                // Display all media items
                if (post.postMedia.isNotEmpty)
                  Container(
                    height: 200,
                    child: _buildPageView(post.postMedia),
                  ),

                // Dots indicator
                if (post.postMedia.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DotsIndicator(
                      itemCount: post.postMedia.length,
                      color: Colors.grey,
                    ),
                  ),

                Container(
                  height: 50,
                  child: const Row(
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
                            text: '@${post.comments[0].commentByUsername} ',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                            style: TextStyle(fontWeight: FontWeight.bold),
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
          );
        },
      );
    });
  }

  Widget _buildPageView(List<PostMedia> postMedia) {
    PageController pageController = PageController();
    return PageView.builder(
      controller: pageController,
      itemCount: postMedia.length,
      itemBuilder: (context, mediaIndex) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child: CachedNetworkImage(
              imageUrl:
                  'https://univsportatech.com/images/${postMedia[mediaIndex].mediaName}',
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class DotsIndicator extends AnimatedWidget {
  final int itemCount;
  final Color color;

  DotsIndicator({
    required this.itemCount,
    required this.color,
  }) : super(listenable: PageController());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey, // Set color based on selectedness
          ),
        );
      }),
    );
  }
}
