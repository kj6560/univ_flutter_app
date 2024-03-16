import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/view/contents/Esports.dart';

import '../../utility/values.dart';
import '../constantpages/MyCustomAppBar.dart';
import '../constantpages/bottomnavigationbar.dart';

class MyEsports extends StatefulWidget {
  const MyEsports({super.key});

  @override
  State<MyEsports> createState() => _MyEsportsState();
}

class _MyEsportsState extends State<MyEsports> {
  var user_name = "";
  var profilePictureUrl="";
  Future<void> loadProfilePicture() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePictureUrl = prefs.getString('image') ?? "";
      user_name =
          prefs.getString("first_name")! + " " + prefs.getString("last_name")!;
    });
    Values.cacheFile('${Values.profilePic}$profilePictureUrl');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProfilePicture();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Esports(profilePicture:profilePictureUrl,user_name:user_name),
      bottomNavigationBar:
      MyBottomNavigationBar(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
