import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyAppBarProfile extends StatefulWidget {
  @override
  State<MyAppBarProfile> createState() => _MyAppBarProfileState();
}

class _MyAppBarProfileState extends State<MyAppBarProfile> {
  String userName = '';
  bool servicestatus = false;
  bool haspermission = false;
  String city="";double temp = 0.0;
  late LocationPermission permission;
  late Position position;
  double long = 0.0, lat = 0.0;
  late StreamSubscription<Position> positionStream;
  String profilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    checkGps();
    loadProfileName();
    loadProfilePicture();
  }
  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    long = position.longitude;
    lat = position.latitude;

    RemoteServices.fetchTemperature(lat, long);

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 5, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) async {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude;
      lat = position.latitude;

      var tempData = await RemoteServices.fetchTemperature(lat, long);
      print(tempData);
      if(tempData !=null){
        setState(() {
          temp = tempData['current']['temp_c'];
          city = tempData['location']['region'];
        });
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

  Future<void> loadProfileName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('first_name') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(26, 188, 156, 70),
      title:  Column(children: [
        Text(
          "Hey ${userName}!",
          style: TextStyle(fontSize: 14),
        ),
        Text(
          city!,
          style: TextStyle(fontSize: 14),
        )
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
      leading: InkWell(
        onTap: () {
          Get.offAllNamed("/user_profile");
        },
        child: CircleAvatar(
            radius: 30,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            backgroundImage:
            CachedNetworkImageProvider(
                '${Values.profilePic}$profilePictureUrl')),
      ),
    );
  }
}
