import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:univ_app/models/user.dart';
import 'package:univ_app/services/remote_services.dart';

import '../utility/DBHelper.dart';
import '../utility/values.dart';

class UserSearchController extends GetxController {
  var users = <User>[].obs;
  var userList = <User>[];
  var user_name = "".obs;
  var show_more = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUsers();
  }

  void fetchUsers({bool filter = false}) async {
    var totalApiData = 0;
    var userCountInDb = await getUsersCount();
    var perpage = 100;
    var page = (userCountInDb / perpage).floor() + 1;
    var allPosts = await RemoteServices.fetchUsers(user_name.value, page);
    var postIntData = jsonDecode(allPosts!);
    totalApiData = postIntData["total"];
    if (userCountInDb != totalApiData) {
      var apiData = usersFromJson(jsonEncode(postIntData["data"]));
      await insertUsers(apiData);
    }
    var usersFromDb = await getUsers(user_name.value);
    if (show_more.value) {
      users.value = users.value + usersFromDb;
    } else {
      users.value = usersFromDb;
    }

    userList = users.value;
  }

  void filterUsers(String query) {
    users.value = userList
        .where((element) =>
            element.userName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void resetFilters() async {
    var usersFromDb = await getUsers(user_name.value);
    users.value = usersFromDb;
    userList = users.value;
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

  Future<List<User>> getUsers(String userName) async {
    var limit = 100;
    final prefs = await SharedPreferences.getInstance();
    var offset = prefs.getInt("offset");
    offset = offset != null ? offset : 0;
    final conn = DBHelper.instance;
    var dbclient = await conn.db;
    List<User> usersLists = [];
    var usersData;
    if (show_more.value) {
      if (userName.isNotEmpty) {
        usersData = await dbclient!.rawQuery(
            "SELECT * FROM users where user_name like '%${userName}%'");
      } else {
        usersData = await dbclient!.rawQuery(
          "SELECT * FROM users order by id desc LIMIT ? OFFSET ?",
          [limit, offset],
        );
        prefs.setInt("offset", limit + offset);
      }
    } else {
      usersData = await dbclient!.rawQuery(
        "SELECT * FROM users order by id desc LIMIT ? OFFSET ?",
        [limit, 0],
      );
    }
    if (usersData.length != 0) {
      for (var dataUser in usersData) {
        User user = User.fromJson(dataUser);
        Values.cacheFile('${Values.profilePic}${user.image}');
        usersLists.add(user);
      }
    }
    return usersLists;
  }

  static Future<int> getUsersCount() async {
    final conn = DBHelper.instance;
    var dbclient = await conn.db;
    var total_count = await Sqflite.firstIntValue(
        await dbclient!.rawQuery('SELECT COUNT(*) FROM users'));
    total_count = total_count != null ? total_count : 0;
    return total_count;
  }
}
