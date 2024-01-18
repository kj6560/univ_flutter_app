import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/userphotoscontroller.dart';
import 'package:univ_app/utility/values.dart';

class UserPhotosGallery extends StatefulWidget {
  @override
  State<UserPhotosGallery> createState() => _UserPhotosGalleryState();
}

class _UserPhotosGalleryState extends State<UserPhotosGallery> {
  UserPhotosController userPhotosController = Get.put(UserPhotosController());

  @override
  Widget build(BuildContext context) {
    return GetX<UserPhotosController>(
      builder: (logic) {
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  color: Colors.grey,
                  child: InkWell(
                      onTap: () {
                        showDialog(
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.all(1),
                            content: ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: 400, maxHeight: 400),
                              child: CachedNetworkImage(
                                fit: BoxFit.contain,
                                // Adjust the fit based on your requirement
                                imageUrl: Values.userGallery +
                                    logic.userFiles[index].filePath,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          context: context,
                        );
                      },
                      child: CachedNetworkImage(
                        height: 150,
                        fit: BoxFit.cover,
                        imageUrl: Values.userGallery +
                            logic.userFiles[index].filePath,
                        // URL of the image
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 3.0),
                        ),
                        // Placeholder widget
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error), // Error widget
                      )),
                ),
              );
            },
            childCount: logic.userFiles.length,
          ),
        );
      },
    );
  }
}
