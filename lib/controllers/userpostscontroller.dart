import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/controllers/socialprofilecontroller.dart';
import 'package:univ_app/models/UserFile.dart';
import 'package:univ_app/models/UserPost.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/models/user.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

class UserPostsController extends GetxController {
  var userPosts = List<UserPost>.empty().obs;
  int postType;
  SocialProfileController socialProfileController =
  Get.put(SocialProfileController());
  UserPostsController({required this.postType});

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
      var userposts = userPostFromJson(allPosts);
      for (var post in userposts) {
        var media = post.postMedia;
        if (media.contains(",")) {
          var imageAr = post.postMedia.split(",");
          post.postMedia = imageAr[0];
          Values.cacheFile(Values.postMediaUrl + imageAr[0]);
        } else {
          Values.cacheFile(Values.postMediaUrl + post.postMedia);
        }
      }
      userPosts.value = userposts;
    }
  }

  Future<bool> deletePost(int post_id) async {
    var deleted = await RemoteServices.deletePost(post_id);
    userPosts.refresh();
    socialProfileController.refresh();
    return deleted;
  }
}
