import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:univ_app/controllers/socialprofilecontroller.dart';
import 'package:univ_app/controllers/usersearchcontroller.dart';

import '../../controllers/eventcontroller.dart';
import '../../utility/values.dart';

class UserSearch extends StatelessWidget {
  UserSearch({super.key});

  UserSearchController userSearchController = Get.put(UserSearchController());
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              controller: editingController,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0),
                  borderSide:
                      const BorderSide(color: Color(0x00ffffff), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0),
                  borderSide:
                      const BorderSide(color: Color(0x00ffffff), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0),
                  borderSide:
                      const BorderSide(color: Color(0x00ffffff), width: 1),
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              onChanged: (value) {
                userSearchController
                    .filterUsers(editingController.text.toString());
              },
            ),
          ),
        ),
        Obx(() => SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              height: 450,
             child: ListView.builder(
               itemCount: userSearchController.users.length,
               itemBuilder: (context, index) {
                 return InkWell(
                   onTap: (){
                     Get.delete<SocialProfileController>();
                     Get.toNamed("/social_profile",
                         arguments: userSearchController.users[index]);
                   },
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       children: [
                         CircleAvatar(
                           radius: 25,
                           foregroundColor: Colors.black,
                           backgroundColor: Colors.white,
                           foregroundImage: CachedNetworkImageProvider(
                             '${Values.profilePic}${userSearchController.users[index].image}',
                           ),
                           backgroundImage:
                           AssetImage("assets/avatar_placeholder.png"),
                         ),
                         Column(
                           children: [
                             Padding(
                               padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                               child: Text(
                                 userSearchController.users[index].firstName +
                                     " " +
                                     userSearchController.users[index].lastName,
                                 style: TextStyle(fontSize: 16),
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                               child: Text(
                                 userSearchController.users[index].userName
                                     .toUpperCase(),
                                 style: TextStyle(fontSize: 14),
                               ),
                             )
                           ],
                         ),
                       ],
                     ),
                   ),
                 );
               },
             )
            ),
          ),
        )),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              height: 40,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(color: Values.primaryColor, width: 0.4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: (){
                      userSearchController.show_more.value = true;
                      userSearchController.user_name.value = editingController.text.toString();
                      userSearchController
                          .fetchUsers();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 16,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Load More",
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      userSearchController.user_name.value = "";
                      userSearchController.fetchUsers();
                      userSearchController.refresh();
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.restart_alt_outlined,
                          size: 16,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Reset",
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
