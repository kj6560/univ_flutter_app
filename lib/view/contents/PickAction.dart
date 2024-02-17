import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:univ_app/controllers/postcontroller.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

import 'LocalVideoPlayerScreen.dart';
import 'VideoPlayerScreen.dart';

class PickAction extends StatelessWidget {
  List<String> options = ['Post', 'Video'];

  TextEditingController postCaptionController = TextEditingController();
  PostController controller = Get.put(PostController());

  Future<void> _fetchGalleryImages() async {
    if (controller.post_type.value == 1) {
      controller.imageFile.clear();
      controller.imageFile.refresh();
      await ImagePicker().pickMultiImage().then((value) {
        controller.imageFile.value = value ?? [];
        controller.refresh();
      });
    } else {
      await ImagePicker().pickVideo(source: ImageSource.gallery).then((value) {
        controller.videoLink.value = value!;
        controller.refresh();
      });
    }
  }

  List<Widget> _prepareMediaList(var imageFiles) {
    if (imageFiles.length > 0) {
      return imageFiles.map((file) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.file(
            File(file.path),
            width: 200.0,
            height: 200.0,
            fit: BoxFit.cover,
          ),
        );
      }).toList();
    } else {
      return [Image.asset("assets/placeholder.png")];
    }
  }

  @override
  Widget build(BuildContext context) {
    RemoteServices.showSnackBar(context);
    return Container(
      margin: EdgeInsets.only(top: 55),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Post Type",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3.0),
                  Row(
                    children: [
                      for (String option in options)
                        Row(
                          children: [
                            option != ""
                                ? Radio(
                                    value: option,
                                    groupValue:
                                        controller.selectedPostType.value,
                                    onChanged: (value) {
                                      controller.selectedPostType.value =
                                          value as String;
                                      if (controller.selectedPostType.value ==
                                          "Post") {
                                        controller.post_type.value = 1;
                                      } else if (controller
                                              .selectedPostType.value ==
                                          "Video") {
                                        controller.post_type.value = 2;
                                      }
                                      controller.refresh();
                                      _fetchGalleryImages();
                                    },
                                  )
                                : Radio(
                                    value: option,
                                    groupValue:
                                        controller.selectedPostType.value,
                                    onChanged: (value) {
                                      controller.selectedPostType.value =
                                          value as String;

                                      if (controller.selectedPostType.value ==
                                          "Post") {
                                        controller.post_type.value = 1;
                                      } else if (controller
                                              .selectedPostType.value ==
                                          "Video") {
                                        controller.post_type.value = 2;
                                      }
                                      _fetchGalleryImages();
                                    },
                                  ),
                            Text(option),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 10.0), // Add some spacing
                ],
              ),
            ),
          ),
          controller.post_type.value == 1
              ? SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 0.0,
                  ),
                  delegate: SliverChildListDelegate(
                      _prepareMediaList(controller.imageFile.value)),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    height: 300,
                    color: Colors.grey,
                    child: LocalVideoPlayerScreen(
                        videoUrl: controller.videoLink.value.path),
                  ),
                ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: postCaptionController..text = "",
                maxLines: null,
                // Setting maxLines to null allows multiple lines
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)),
                    hintText: 'Describe about the post in 512 chars max',
                    helperText: 'Describe about the post',
                    labelText: 'Post Caption',
                    prefixIcon: Icon(
                      Icons.info,
                      color: Colors.green,
                    ),
                    prefixText: ' ',
                    suffixStyle: TextStyle(color: Colors.green)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        if (controller.post_type.value == 1) {
                          List<PostMedia> mediaFiles = [];
                          int i = 0;
                          for (XFile? imageFile in controller.imageFile.value) {
                            PostMedia pm = PostMedia(
                                mediaName: imageFile!.path,
                                mediaType: 1,
                                mediaPosition: ++i,
                                path: imageFile.path);
                            mediaFiles.add(pm);
                          }
                          print("reached post create");
                          PostController.createPost(
                              mediaFiles,
                              postCaptionController.text,
                              controller.post_type.value,
                              context);
                        } else if (controller.post_type.value == 2) {
                          List<PostMedia> mediaFiles = [];
                          PostMedia pm = PostMedia(
                              mediaName: controller.videoLink.value.path,
                              mediaType: 2,
                              mediaPosition: 1,
                              path: controller.videoLink.value.path);
                          mediaFiles.add(pm);
                          PostController.createPost(
                              mediaFiles,
                              postCaptionController.text,
                              controller.post_type.value,
                              context);
                        }
                      },
                      child: const Text("Create Post")),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
