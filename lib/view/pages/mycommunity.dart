import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/communitycontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/MyCustomAppBarCommunity.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/communitybottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/constantpages/mycommunityappbar.dart';
import 'package:univ_app/view/contents/Community.dart';

import '../../utility/values.dart';

class MyCommunity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(

      resizeToAvoidBottomInset: false,
      appBar: MyCustomAppBarCommunity("Community"),
      body: Community(),
      bottomNavigationBar: MyCommunityBottomNavigationBar(),
    );
  }
}
