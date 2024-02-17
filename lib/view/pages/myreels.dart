import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/view/constantpages/communitybottomnavigationbar.dart';
import '../contents/Reels.dart';

class MyReels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: Reels(
        index: Get.arguments["index"] ?? 0,
      ),
      bottomNavigationBar: MyCommunityBottomNavigationBar(),
    );
  }
}
