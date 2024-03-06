import 'package:flutter/material.dart';
import 'package:univ_app/view/constantpages/MyCustomAppBarCommunity.dart';
import 'package:univ_app/view/contents/Followers.dart';

import '../constantpages/communitybottomnavigationbar.dart';

class MyFollowers extends StatelessWidget {
  const MyFollowers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBarCommunity("Followers"),
      body: Followers(),
      bottomNavigationBar: MyCommunityBottomNavigationBar(),
    );
  }
}
