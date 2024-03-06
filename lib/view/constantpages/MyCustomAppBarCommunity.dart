import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utility/values.dart';

class MyCustomAppBarCommunity extends AppBar {
  MyCustomAppBarCommunity(title)
      : super(
          backgroundColor: Values.primaryColor,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title),
            ],
          ),
          elevation: 8,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.white, Values.primaryColor]),
            ),
          ),
        );
}
