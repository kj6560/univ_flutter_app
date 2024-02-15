import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/UserFile.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

import '../models/UserPost.dart';
import '../models/user.dart';

class UserVideosController extends GetxController {
  var userPosts = List<UserPost>.empty().obs;
  int postType;

  UserVideosController({required this.postType});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUserPost();
  }

  void fetchUserPost() async {
    User? data = Get.arguments;
    int? id = 0;
    if (data != null) {
      id = data.id;
    } else {
      final prefs = await SharedPreferences.getInstance();
      id = await prefs.getInt("id");
    }

    var allPosts = await RemoteServices.fetchUserPost(id!, this.postType);
    if (allPosts != null) {
      userPosts.value = userPostFromJson(allPosts);
      for (var post in userPosts.value) {
        if (this.postType == 1) {
          var imageAr = post.postMedia.split(",");
          Values.cacheFile(Values.postMediaUrl + imageAr[0]);
        } else {
          Values.cacheFile(Values.postMediaUrl + post.postMedia);
        }
      }
    }
  }

  Future<bool> deletePost(int post_id) async {
    var deleted = await RemoteServices.deletePost(post_id);
    userPosts.remove(userPosts.singleWhere((element) => element.id == post_id));
    userPosts.refresh();
    return deleted;
  }
}
