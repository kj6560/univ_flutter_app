import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/user.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/contents/SocialProfile.dart';

import '../../controllers/socialprofilecontroller.dart';
import '../../services/remote_services.dart';
import '../../utility/DBHelper.dart';
import '../../utility/values.dart';

class MySocialProfile extends StatefulWidget {
  const MySocialProfile({super.key});

  @override
  State<MySocialProfile> createState() => _MySocialProfileState();
}

class _MySocialProfileState extends State<MySocialProfile> {
  var user_id = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  void deleteSocialProfileController()async{
    if(await Get.delete<SocialProfileController>()){
      print("delete social profile controller");
    }
  }
  void setUpUser() async {
    final prefs = await SharedPreferences.getInstance();
    var loggedinUserId = prefs.getInt("id");
    setState(() {
      user_id = loggedinUserId!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Colors.white,
        ),
      ),
      body: SocialProfile(),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}

class TheSocialProfile extends StatefulWidget {
  const TheSocialProfile({
    super.key,
    required this.user_id,
  });

  final int user_id;

  @override
  State<TheSocialProfile> createState() => _TheSocialProfileState();
}

class _TheSocialProfileState extends State<TheSocialProfile> {
  var profilePic = "";
  var profileName = "";
  var about = "";
  var loggedout = false;
  var following = 0;
  var followers = 0;
  var followed = 0;
  var isCurrentUser = false;
  var posts = 0;
  var check_user = 0;
  var user_id = 0;
  var isLoading = false;
  var user;

  @override
  void initState() {
    // TODO: implement initState
    fetchProfile();
    super.initState();
    setUpFollowersData();
  }

  void fetchProfile() async {
    var prefs = await SharedPreferences.getInstance();
    if (widget.user_id == prefs.getInt("id")) {
      setState(() {
        isCurrentUser = true;
      });
    }
    if (widget.user_id != 0) {
      final conn = DBHelper.instance;
      var dbclient = await conn.db;
      var userData = await dbclient!
          .rawQuery('SELECT * FROM users where id=?', [widget.user_id]);
      if (userData.length == 1) {
        user = User.fromJson(userData.first);
      } else {
        var response = await RemoteServices.fetchUserById(widget.user_id);
        user = User.fromJson(jsonDecode(response!));
      }
      setState(() {
        profilePic = user.image;
        profileName = "${user.firstName} ${user.lastName}";
        about = user.about;
        check_user = user.id;
      });
    } else {
      profileName =
          "${prefs.getString("first_name")} ${prefs.getString("last_name")}";
      profilePic = prefs.getString("image")!;
      about = prefs.getString("about")!;
      check_user = prefs.getInt("id")!;
    }
  }

  void setUpFollowersData() async {
    var prefs = await SharedPreferences.getInstance();
    var currentUserId = prefs.getInt("id");
    if (widget.user_id == 0) {
      setState(() {
        isCurrentUser = true;
      });
    }
    int? followed_id = widget.user_id == 0 ? currentUserId : widget.user_id;
    int current_user_profile = isCurrentUser ? 1 : 0;
    var response = await RemoteServices.fetchFollowerData(
        followed_id!, current_user_profile);
    if (response != null) {
      setState(() {
        followers = response['followers'] ?? 0;
        following = response['following'] ?? 0;
        followed = response['is_following'] ?? 0;
        posts = response['posts'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin:
                const EdgeInsets.only(left: 0, top: 5, right: 10, bottom: 0),
            child: isLoading
                ? Container(
                    color: Values.primaryColor.withOpacity(0.2),
                    child: const Center(
                        child:
                            CircularProgressIndicator())) // Show progress indicator when loading
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (user == null) {
                              //_showBottomSheet(context);
                            }
                          },
                          icon: const Icon(
                            FontAwesomeIcons.ellipsisVertical,
                            size: 18,
                          ))
                    ],
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 5, top: 5, right: 0, bottom: 0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 42,
                            backgroundColor: Colors.black,
                            child: user == null
                                ? InkWell(
                                    onTap: () {
                                      //_pickProfileImage();
                                    },
                                    child: CircleAvatar(
                                        radius: 40,
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.white,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                Values.profilePic +
                                                    profilePic)),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    backgroundImage: CachedNetworkImageProvider(
                                        Values.profilePic + profilePic)),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 0, top: 5, right: 0, bottom: 0),
                              child: Column(
                                children: [
                                  Text(profileName,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  InkWell(
                                      onTap: () {
                                        Get.toNamed("/user_profile");
                                      },
                                      child: const Text(
                                        "Edit",
                                        style: TextStyle(
                                            color: Values.primaryColor,
                                            fontSize: 16),
                                      ))
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            //posts
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 5, top: 0, right: 10, bottom: 0),
                                child: Column(
                                  children: [
                                    Text("${posts}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        )),
                                    const Text("Posts",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        )),
                                  ],
                                )),
                            //following
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 5, top: 0, right: 10, bottom: 0),
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed("/followings", arguments: user);
                                  },
                                  child: Column(
                                    children: [
                                      Text("${following}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          )),
                                      const Text("Following",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                )),
                            //followers
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 5, top: 0, right: 10, bottom: 0),
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed("/followers", arguments: user);
                                  },
                                  child: Column(
                                    children: [
                                      Text("${followers}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          )),
                                      const Text("Followers",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(height: 1),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                child: Text(about,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    )),
              )),
        ),
        !isCurrentUser
            ? SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            followed == 1 ? "FOLLOWED" : "FOLLOW",
                          )),
                      SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              onPressed: () {}, child: const Text("Message")))
                    ],
                  ),
                ),
              )
            : SliverToBoxAdapter(
                child: SizedBox(
                  height: 1,
                ),
              )
      ],
    );
  }
}
