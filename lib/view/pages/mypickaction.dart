import 'package:flutter/material.dart';
import 'package:univ_app/view/constantpages/MyCustomAppBarCommunity.dart';
import 'package:univ_app/view/constantpages/communitybottomnavigationbar.dart';
import 'package:univ_app/view/contents/PickAction.dart';

class MyPickAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBarCommunity("Create Post"),
      body: PickAction(),
      bottomNavigationBar: MyCommunityBottomNavigationBar(),
    );
  }
}

