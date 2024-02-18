import 'package:flutter/material.dart';
import 'package:univ_app/view/constantpages/communitybottomnavigationbar.dart';
import 'package:univ_app/view/contents/PickAction.dart';

class MyPickAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: PickAction(),
      bottomNavigationBar: MyCommunityBottomNavigationBar(),
    );
  }
}

