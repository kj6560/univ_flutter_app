import 'package:get/get.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';

class PostController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  static void createPost(List<PostMedia> mediaFiles, String caption,int post_type) async {
      RemoteServices.createPost(mediaFiles,caption,post_type);
  }
}
