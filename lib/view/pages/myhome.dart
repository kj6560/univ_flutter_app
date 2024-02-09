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

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  SliderController sliderController = Get.put(SliderController());
  EventController eventController = Get.put(EventController());
  TextEditingController editingController = TextEditingController();

  String image = "";

  @override
  Widget build(BuildContext context) {
    // Set the system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.dark, // Dark icons on the status bar
      systemNavigationBarColor: Colors.blue, // Color of the system navigation bar (taskbar)
      systemNavigationBarIconBrightness: Brightness.light, // Dark icons on the system navigation bar
    ));

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: MyAppBar(),
        ),
        body: Home(),
        bottomNavigationBar: MyBottomNavigationBar(),
      ),
    );
  }
}
