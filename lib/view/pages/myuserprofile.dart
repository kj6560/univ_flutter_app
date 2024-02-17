import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/constantpages/myappbarprofile.dart';
import 'package:univ_app/view/contents/SocialProfile.dart';
import 'package:univ_app/view/contents/UserProfile.dart';

class MyUserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: MyAppBarProfile(),
      ),
      body: UserProfile(),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
