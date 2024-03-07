import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:univ_app/models/category.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/DBHelper.dart';

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
    final conn = DBHelper.instance;
    var dbclient = await conn.db;
    List<Category>? all_categories = [];
    try{
      all_categories = await RemoteServices.fetchCategories();
      var total_count = await Sqflite.firstIntValue(
          await dbclient!.rawQuery('SELECT COUNT(*) FROM sports'));
      var hasInternet = await RemoteServices.hasInternet();
      if (hasInternet) {
        if (all_categories != null && total_count != all_categories.length) {
          for(var category in all_categories){
            await dbclient!.insert('sports', category.toJson());
          }
        }
      }else{
        List<Map<String, dynamic>> maps = await dbclient!.query('sports');
        maps.forEach((element) {
          Category ev = Category.fromMap(element);
          all_categories?.add(ev);
        });
      }

      categories.value = all_categories!;
      initialCategory.value = all_categories.first.name;
    }catch(e){
      print(e);
    }

  }
}
