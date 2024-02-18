import 'dart:convert';

import 'package:get/get.dart';

import 'package:univ_app/models/post.dart';
import 'package:univ_app/models/user.dart';
import 'package:univ_app/services/remote_services.dart';

import '../utility/DBHelper.dart';
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

    List<User> usersInDb = await getUsers();
    var allPosts = await RemoteServices.fetchUsers(user_name.value);
    if (allPosts != null) {
      var response = usersFromJson(allPosts);
      if (usersInDb.length != response.length) {
        for (User user in response) {
          try {
            if (user.image != null || user.image != "") {
              Values.cacheFile('${Values.profilePic}${user.image}');
            }
          } catch (e) {}
        }
        insertUsers(response);
        users.value = response;
      } else if (usersInDb.length == response.length) {
        users.value = usersInDb;
      }
    } else {
      print("total users in db: ${usersInDb.length}");
      users.value = usersInDb;
    }
    userList = users.value;
  }

  void filterUsers(String query) {
    users.value = userList
        .where((element) =>
            element.userName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static Future<void> insertUsers(List<User> users) async {
    final conn = DBHelper.instance;
    var dbclient = await conn.db;

    for (var user in users) {
      // Check if the user already exists in the 'users' table
      List<Map<String, dynamic>> existingUsers = await dbclient!.query(
        'users',
        where: 'id = ?',
        whereArgs: [user.id],
      );

      if (existingUsers.isEmpty) {
        // If the user does not exist, insert it into the 'users' table
        await dbclient.insert('users', user.toJson());
      }
    }
  }

  static Future<List<User>> getUsers() async {
    final conn = DBHelper.instance;
    var dbclient = await conn.db;
    List<Map<String, dynamic>> usersData = await dbclient!.rawQuery('select * from users order by id desc');

    return usersData.map((userData) => User.fromJson(userData)).toList();
  }
}
