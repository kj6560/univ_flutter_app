import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:univ_app/models/category.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/DBHelper.dart';

class MessengerController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchMessegesList();
  }

  void fetchMessegesList() async {}
}
