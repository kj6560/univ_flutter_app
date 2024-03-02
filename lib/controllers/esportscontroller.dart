

import 'dart:convert';

import 'package:get/get.dart';
import 'package:univ_app/models/esports.dart';
import 'package:univ_app/services/remote_services.dart';

class EsportsController extends GetxController {

  var header_text = "".obs;
  var images = List<String>.empty().obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchEsportsData();
  }

  void fetchEsportsData() async {
      var response = await RemoteServices.fetchEsportsData();
      if(response != null){
        var esportsData = jsonDecode(response);
        Esports esports = Esports(id: esportsData.id, headerText: esportsData.header_text, images: esportsData.images, status: esportsData.status, createdAt: esportsData.createdAt, updatedAt: esportsData.updatedAt);
        header_text.value = esports.headerText;
        var _images = esports.images;
        images.value = _images.split(",");
      }
  }
}
