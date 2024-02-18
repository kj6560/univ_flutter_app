import 'package:flutter/material.dart';
import 'package:univ_app/view/contents/Followers.dart';

import '../constantpages/communitybottomnavigationbar.dart';

class MyFollowers extends StatelessWidget {
  const MyFollowers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: Followers(),
      bottomNavigationBar: MyCommunityBottomNavigationBar(),
    );
  }
}
