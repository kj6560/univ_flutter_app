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
import 'package:univ_app/view/contents/PickAction.dart';

class MyPickAction extends StatefulWidget {
  const MyPickAction({super.key});

  @override
  State<MyPickAction> createState() => _MyPickActionState();
}

class _MyPickActionState extends State<MyPickAction> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.white, // Set the status bar color here
    // ));
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55), // Set this height
          child: MyCommunityAppBar(),
        ),
        body: PickAction(),
        bottomNavigationBar: MyCommunityBottomNavigationBar(),
      ),
    );
  }
}
