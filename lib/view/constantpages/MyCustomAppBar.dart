import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utility/values.dart';

class MyCustomAppBar extends AppBar {
  MyCustomAppBar({temp, showBack, context, profilePictureUrl, topQuote, city})
      : super(
          backgroundColor: Values.primaryColor,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showBack
                  ? InkWell(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                          Get.offAllNamed(Get.previousRoute);
                        },
                      ),
                    )
                  : Container(),
              SizedBox(
                height: kToolbarHeight,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 45,
                    child: InkWell(
                      onTap: () {
                        Get.offAllNamed("/user_profile");
                      },
                      child: CircleAvatar(
                        radius: 25,
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        backgroundImage: CachedNetworkImageProvider(
                          '${Values.profilePic}$profilePictureUrl',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      topQuote.length > 25
                          ? topQuote.substring(0, 20) +
                              "\n" +
                              topQuote.substring(20, topQuote.length)
                          : topQuote,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "${city}       ${temp!} °C",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[

            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ],
          elevation: 8,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Values.primaryColor, Colors.teal]),
            ),
          ),
        );
}
