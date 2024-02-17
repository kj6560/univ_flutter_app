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

class MyCommunity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Community",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
      body: Community(),
      bottomNavigationBar: MyCommunityBottomNavigationBar(),
    );
  }
}
