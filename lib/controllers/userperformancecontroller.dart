import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/DynamicModel.dart';
import 'package:univ_app/models/category.dart';
import 'package:univ_app/services/remote_services.dart';

class UserPerformanceController extends GetxController {
  var performanceData = List<DynamicModel>.empty();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUserPerformance();
  }

  void fetchUserPerformance() async {
    final prefs = await SharedPreferences.getInstance();
    int? id = await prefs.getInt("id");
    var performances = await RemoteServices.fetchUserPerformance(id);
    if (performances != null) {
      performanceData = dynamicModelFromJson(performances);
      update();
    }
  }
}
