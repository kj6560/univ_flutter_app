import 'package:get/get.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';

class LikesController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<List<Comment>> fetchComments(var post_id) async {
    var response = await RemoteServices.fetchComments(post_id);
    List<Comment> comments = commentFromJson(response);
    return comments;
  }


}
