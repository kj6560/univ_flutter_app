import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/controllers/eventcontroller.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/contents/Home.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/utility/values.dart';

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: MyAppBar(),
      ),
      body: Home(),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
