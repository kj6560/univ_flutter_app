import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/view/constantpages/MyCustomAppBar.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/contents/EventsList.dart';

import '../../services/remote_services.dart';
import '../../utility/values.dart';
class MyEventsList extends StatefulWidget {
  const MyEventsList({super.key});

  @override
  State<MyEventsList> createState() => _MyEventsListState();
}

class _MyEventsListState extends State<MyEventsList> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("UNIV Events",style: TextStyle(color: Colors.white),),
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Values.primaryColor, Colors.teal]),
          ),
        ),
      ),
      body: EventsList(),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
