import 'dart:convert';

import 'package:get/get.dart';

import 'package:univ_app/models/post.dart';
import 'package:univ_app/models/user.dart';
import 'package:univ_app/services/remote_services.dart';

import '../utility/values.dart';

class UserSearchController extends GetxController {
  var users = <User>[].obs;
  var userList = <User>[];
  RxString user_name = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUsers(user_name.value);
  }

  void fetchUsers(String user__name) async {
    user_name.value = user__name;
    var allPosts = await RemoteServices.fetchUsers(user_name.value);
    if (allPosts != null) {
      var response = usersFromJson(allPosts);
      for(User user in response){
        Values.cacheFile('${Values.profilePic}${user.image}');
      }
      users.value = response;
    }
    userList = users.value;
  }

  void filterUsers(String query) {
    users.value = userList
        .where((element) =>
        element.userName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
