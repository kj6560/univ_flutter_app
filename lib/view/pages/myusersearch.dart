import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/communitycontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/communitybottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/constantpages/mycommunityappbar.dart';
import 'package:univ_app/view/constantpages/mycommunityusersearchappbar.dart';
import 'package:univ_app/view/contents/PickAction.dart';
import 'package:univ_app/view/contents/UserSearch.dart';

class MyUserSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: UserSearch(),
      bottomNavigationBar: MyCommunityBottomNavigationBar(),
    );
  }
}
