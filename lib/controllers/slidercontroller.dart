import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import 'package:univ_app/models/sliders.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:univ_app/utility/DBHelper.dart';

import '../utility/values.dart';

class SliderController extends GetxController {
  var sliders = List<Sliders>.empty().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchSliders();
  }

  void fetchSliders() async {
    final conn = DBHelper.instance;
    var dbclient = await conn.db;
    List<Sliders>? all_sliders = [];
    try {
      var total_count = await Sqflite.firstIntValue(
          await dbclient!.rawQuery('SELECT COUNT(*) FROM sliders'));
      var hasInternet = await RemoteServices.hasInternet();
      if (hasInternet) {
        all_sliders = await RemoteServices.fetchSliders();
        if (all_sliders != null && total_count != all_sliders.length) {
          for (var slider in all_sliders) {
            print(slider.toJson());
            await dbclient!.insert('sliders', slider.toJson());
            Values.cacheFile('${Values.sliderImageUrl}/${slider.image}');
            sliders.add(

                Sliders(image: '${Values.sliderImageUrl}/${slider.image}'));
          }
        }
      } else {
        List<Map<String, dynamic>> maps =
        await dbclient!.rawQuery('SELECT * FROM sliders');
        maps.forEach((element) {
          Sliders slider = Sliders.fromMap(element);
          all_sliders?.add(slider);
        });

      }
      sliders.value = all_sliders!;

    } catch (e) {}
  }
}
