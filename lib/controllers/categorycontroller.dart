import 'package:get/get.dart';
import 'package:univ_app/models/category.dart';
import 'package:univ_app/services/remote_services.dart';

class CategoryController extends GetxController {
  var categories = List<Category>.empty().obs;
  var initialCategory = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCategory();
  }

  void fetchCategory() async {
    var all_categories = await RemoteServices.fetchCategories();
    if (all_categories != null) {
      categories.value = all_categories;
      initialCategory.value = all_categories.first.name;
    }
  }
}
