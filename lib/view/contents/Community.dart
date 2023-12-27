import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/communitycontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';

class Community extends StatefulWidget {
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  CommunityController communityController = Get.put(CommunityController());

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Change the duration as needed
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCirc,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(builder: (logic) {
      return  CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(child: Text("hello total data in posts")),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              mainAxisSpacing: 8.0, // Spacing between rows
              crossAxisSpacing: 8.0, // Spacing between columns
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Text("${logic.posts[index].postCaption}");
              },
              childCount: logic.posts.length,
            ),
          ),
        ],
      );
    });
  }
}
