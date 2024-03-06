import 'package:flutter/material.dart';
import 'package:univ_app/view/constantpages/MyCustomAppBarCommunity.dart';
import 'package:univ_app/view/contents/Followings.dart';

import '../constantpages/communitybottomnavigationbar.dart';

class MyFollowings extends StatelessWidget {
  const MyFollowings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBarCommunity("Following"),
      body: Followings(),
      bottomNavigationBar: MyCommunityBottomNavigationBar(),
    );
  }
}
