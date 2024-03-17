import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/appbarcontroller.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  bool servicestatus = false;
  bool haspermission = false;
  String city = "";
  var temp = 0.0;
  late LocationPermission permission;
  late Position position;
  double long = 0.0, lat = 0.0;
  late StreamSubscription<Position> positionStream;
  bool disposed = false;
  String profilePictureUrl = '';
  var showBack = false;
  var topQuote = "";
  AppbarController appbarController = Get.put(AppbarController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposed = true;
  }

  @override
  void initState() {
    super.initState();
    if (Get.currentRoute.contains("/event_gallery")) {
      setState(() {
        showBack = true;
      });
    }
    checkGps();
    loadProfilePicture();
    loadTopQuote();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
      if (haspermission) {
        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    long = position.longitude;
    lat = position.latitude;
    //print("lat: $lat,lon: $long");
    RemoteServices.fetchTemperature(lat, long);

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 5, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) async {
      if (!disposed) {
        long = position.longitude;
        lat = position.latitude;

        var tempData = await RemoteServices.fetchTemperature(lat, long);
        if (tempData != null) {
          setState(() {
            temp = tempData['current']['temp_c'];
            city = tempData['location']['region'];
          });
        }
      }
    });
  }

  Future<void> loadProfilePicture() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePictureUrl = prefs.getString('image') ?? "";
    });
    Values.cacheFile('${Values.profilePic}$profilePictureUrl');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                      Get.toNamed(Get.previousRoute);
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
                    Get.toNamed("/user_profile");
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
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                Text(
                  city ?? '',
                  style: const TextStyle(fontSize: 14),
                )
              ],
            ),
          ),
        ],
      ),
      actions: [
        // action button
        Center(
          child: Text(
            "${temp!} °C",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        )
      ],
    );
  }

  void loadTopQuote() async {
    var resp = await RemoteServices.fetchTopQuote();
    if (resp != null) {
      if (resp.length > 30) {
        resp = "${resp.substring(0, 30)}\n${resp.substring(31, resp.length)}";
      }
      setState(() {
        topQuote = resp!;
      });
    }
  }
}
