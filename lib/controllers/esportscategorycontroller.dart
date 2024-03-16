import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:univ_app/models/category.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/DBHelper.dart';

class EsportsCategoryController extends GetxController {
  var categories = List<Category>.empty().obs;
  var initialCategory = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCategory();
  }

  void fetchCategory() async {

    final conn = DBHelper.instance;
    var dbclient = await conn.db;
    List<Category>? all_categories = [];
    try {
      all_categories = await RemoteServices.fetchEsportsCategories();

      categories.value = all_categories!;
      initialCategory.value = all_categories.first.name;
      categories.insert(0, Category(
          id: 0,
          name: "All",
          description: "all",
          icon: "",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()));
      initialCategory.value = "All";
    } catch (e) {
      print(e);
    }
  }
}
