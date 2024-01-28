import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:univ_app/view/pages/mycommunity.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCommunityUserSearchAppBar extends StatefulWidget {
  @override
  State<MyCommunityUserSearchAppBar> createState() => _MyCommunityUserSearchAppBarState();
}

class _MyCommunityUserSearchAppBarState extends State<MyCommunityUserSearchAppBar> {



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

        ],
      ),
      actions: [
        // action button


      ],
    );
  }
}
