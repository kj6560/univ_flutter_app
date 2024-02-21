import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/followerscontroller.dart';

import '../../utility/values.dart';

class Followers extends StatelessWidget {
  final followersController = Get.put(FollowersController());
  TextEditingController userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: !Platform.isAndroid
          ? const EdgeInsets.only(top: 55)
          : const EdgeInsets.only(top: 10),
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(25.0, 2.0, 0.0, 20.0),
              child: Text(
                "Followers",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: userController,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide: const BorderSide(
                            color: Color(0x00ffffff), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide: const BorderSide(
                            color: Color(0x00ffffff), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide: const BorderSide(
                            color: Color(0x00ffffff), width: 1),
                      ),
                      hintText: "Search User",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      filled: true,
                      fillColor: const Color(0xfff2f2f3),
                      isDense: false,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                    ),
                    onChanged: (value) {
                      if (value.length > 2) {
                        followersController.user_name.value = value;
                        followersController.filterUsers(value);
                      } else {
                        followersController.fetchFollowers(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          GetX<FollowersController>(builder: (logic) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          logic.userList[index].image != null ||
                                  logic.userList[index].image != ""
                              ? CircleAvatar(
                                  radius: 25,
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  foregroundImage: CachedNetworkImageProvider(
                                    '${Values.profilePic}${logic.userList[index].image}',
                                  ),
                                  backgroundImage: const AssetImage(
                                      "assets/avatar_placeholder.png"),
                                )
                              : const CircleAvatar(
                                  radius: 25,
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                      "assets/avatar_placeholder.png"),
                                ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                  "${Values.capitalize(logic.userList[index].firstName)} ${logic.userList[index].lastName}"),
                              Text(Values.capitalize(
                                  logic.userList[index].userName))
                            ],
                          )
                        ],
                      ),
                      onTap: () {
                        Get.offAllNamed("/social_profile",
                            arguments: logic.userList[index]);
                      },
                    ),
                  );
                },
                childCount: logic.followers.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}
