import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/view/constantpages/communitybottomnavigationbar.dart';
import '../contents/Reels.dart';

class MyReels extends StatefulWidget {
  const MyReels({super.key});

  @override
  State<MyReels> createState() => _MyReelsState();
}
class _MyReelsState extends State<MyReels> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose gettinng called");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: Reels(
        index: Get.arguments !=null && Get.arguments["index"] !=0 ? Get.arguments["index"] : 0,
      ),
    );
  }
}
