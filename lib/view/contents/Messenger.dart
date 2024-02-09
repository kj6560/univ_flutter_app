import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/controllers/communitycontroller.dart';
import 'package:univ_app/controllers/messengercontroller.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/utility/values.dart';

class Messenger extends StatefulWidget {
  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger>
    with SingleTickerProviderStateMixin {
  int? current_user_id = 0;

  @override
  void initState() {
    super.initState();
    setCurrentUser();
  }

  setCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      current_user_id = prefs.getInt("id")!;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Center(child: Text("Coming Soon"))],
    );
  }
}
