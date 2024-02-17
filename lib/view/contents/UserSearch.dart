import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/usersearchcontroller.dart';

import '../../utility/values.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({super.key});

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  TextEditingController userController = TextEditingController();
  UserSearchController userSearchController = Get.put(UserSearchController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 55),
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
                      if (value.length > 2) {
                        userSearchController.user_name.value = value;
                        userSearchController.filterUsers(value);
                      } else {
                        userSearchController.fetchUsers(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          GetX<UserSearchController>(builder: (logic) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          logic.userList[index].image.isNotEmpty
                              ? CircleAvatar(
                            radius: 25,
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            backgroundImage: CachedNetworkImageProvider(
                              '${Values.profilePic}${logic.userList[index]
                                  .image}',
                            )
                          )
                              : const CircleAvatar(
                            radius: 25,
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage("assets/placeholder.png"),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text("${Values.capitalize(
                                  logic.userList[index].firstName)} ${logic
                                  .userList[index].lastName}"),
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
                childCount: logic.users.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}
