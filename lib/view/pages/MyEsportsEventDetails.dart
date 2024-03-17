import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/view/contents/Esports.dart';
import 'package:univ_app/view/contents/EsportsEventDetails.dart';

import '../../utility/values.dart';
import '../constantpages/MyCustomAppBar.dart';
import '../constantpages/bottomnavigationbar.dart';
import '../constantpages/esportsbottomnavigationbar.dart';

class MyEsportsEventDetails extends StatefulWidget {
  const MyEsportsEventDetails({super.key});

  @override
  State<MyEsportsEventDetails> createState() => _MyEsportsEventDetailsState();
}

class _MyEsportsEventDetailsState extends State<MyEsportsEventDetails> {
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

      body: EsportsEventDetails(profilePicture:profilePictureUrl,user_name:user_name),
      bottomNavigationBar:
      MyEsportsBottomNavigationBar(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
