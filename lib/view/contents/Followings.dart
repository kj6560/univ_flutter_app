import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

import '../../controllers/followingcontroller.dart';
import '../../utility/values.dart';

class Followings extends StatelessWidget {
  final followingController = Get.put(FollowingController());
  TextEditingController userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
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
                      hintText: "Search",
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
                        followingController.user_name.value = value;
                        followingController.filterUsers(value);
                      } else {
                        followingController.fetchFollowers(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          GetX<FollowingController>(builder: (logic) {
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
                                  backgroundImage: AssetImage(
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
