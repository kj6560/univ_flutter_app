import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/communitycontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/communitybottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/constantpages/mycommunityappbar.dart';
import 'package:univ_app/view/contents/Community.dart';
import 'package:univ_app/view/contents/PostDetail.dart';
import 'package:univ_app/view/contents/SocialProfile.dart';

class MyPostDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: PostDetail(),
      bottomNavigationBar: MyCommunityBottomNavigationBar(),
    );
  }
}
