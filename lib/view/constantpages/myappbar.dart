import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
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
        setState(() {
          //refresh the UI
        });

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

    RemoteServices.fetchTemperature(lat, long);

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 5, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
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
                Get.offAllNamed(Get.previousRoute);
              },
            ),
          )
              : Container(),
          SizedBox(
            height: kToolbarHeight, // Set the height of SizedBox equal to the AppBar height
            child: Center(
              child: Container(
                alignment: Alignment.center,
                height: 45, // Set the height of the container to adjust the size of CircleAvatar
                width: 45, // Set the width of the container to adjust the size of CircleAvatar
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
                  "A great day to run",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  city ?? '',
                  style: TextStyle(fontSize: 14),
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
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        )
      ],
    );
  }


}
