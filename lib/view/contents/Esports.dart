import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/esportscontroller.dart';

import '../../utility/values.dart';

class Esports extends StatelessWidget {
  Esports({super.key});

  final EsportsController controller = Get.put(EsportsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "UNIV ESPORTS",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ARENA",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
                    child: Text(
                      "${controller.header_text}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: controller.images.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(Values.esportsImageUrl + controller.images[index].replaceAll("\"", ""));
                    return Card(
                        child: GridTile(
                      child: CachedNetworkImage(
                        fit: BoxFit.fitHeight,
                        // Adjust the fit based on your requirement
                        imageUrl:
                            Values.esportsImageUrl + controller.images[index].replaceAll("\"", "").replaceAll("[", "").replaceAll("]", ""),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ));
                  },
                ),
              ),
            )
          ],
        ));
  }
}
