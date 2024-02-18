import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:univ_app/controllers/postcontroller.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

import 'LocalVideoPlayerScreen.dart';

class PickAction extends StatefulWidget {
  @override
  State<PickAction> createState() => _PickActionState();
}

class _PickActionState extends State<PickAction>
    with SingleTickerProviderStateMixin {
  String selectedPostType = 'Post';
  List<String> options = ['Post', 'Video'];
  List<XFile> _imageFile = [];
  XFile? videoLink;
  TextEditingController postCaptionController = TextEditingController();
  int post_type = 1;
  var isLoading = false;

  Future<void> _fetchGalleryImages() async {
    if (post_type == 1) {
      await ImagePicker().pickMultiImage().then((value) {
        setState(() {
          _imageFile = value ?? [];
        });
      });
    } else {
      await ImagePicker().pickVideo(source: ImageSource.gallery).then((value) {
        if (value != null) {
          setState(() {
            videoLink = value;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    RemoteServices.showSnackBar(context);
  }

  List<Widget> _prepareMediaList(List<XFile> imageFiles) {
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
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.fromLTRB(8.0, 50, 0, 0),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Post Type",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (String option in options)
                        Row(
                          children: [
                            option != ""
                                ? Radio(
                                    value: option,
                                    groupValue: selectedPostType,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPostType = value as String;
                                      });
                                      if (selectedPostType == "Post") {
                                        post_type = 1;
                                      } else if (selectedPostType == "Video") {
                                        post_type = 2;
                                      }
                                    },
                                  )
                                : Radio(
                                    value: option,
                                    groupValue: selectedPostType,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPostType = value as String;
                                      });
                                      if (selectedPostType == "Post") {
                                        post_type = 1;
                                      } else if (selectedPostType == "Video") {
                                        post_type = 2;
                                      }
                                      _fetchGalleryImages();
                                    },
                                  ),
                            Text(option),
                          ],
                        ),
                      ElevatedButton(
                          onPressed: () {
                            _fetchGalleryImages();
                          },
                          child: Text("Select"))
                    ],
                  ),
                ),
                const SizedBox(height: 10.0), // Add some spacing
              ],
            ),
          ),
        ),
        post_type == 1
            ? SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                ),
                delegate: SliverChildListDelegate(
                  _prepareMediaList(_imageFile),
                ),
              )
            : SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  color: Colors.grey,
                  child: videoLink != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              LocalVideoPlayerScreen(videoUrl: videoLink!.path),
                        )
                      : SizedBox(
                          height: 1,
                        ),
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
                      setState(() {
                        isLoading = true;
                      });
                      List<PostMedia> mediaFiles = [];
                      if (post_type == 1) {
                        int i = 0;
                        for (XFile imageFile in _imageFile) {
                          PostMedia pm = PostMedia(
                            mediaName: imageFile.path,
                            mediaType: 1,
                            mediaPosition: ++i,
                            path: imageFile.path,
                          );
                          mediaFiles.add(pm);
                        }
                      } else if (post_type == 2 && videoLink != null) {
                        PostMedia pm = PostMedia(
                          mediaName: videoLink!.path,
                          mediaType: 2,
                          mediaPosition: 1,
                          path: videoLink!.path,
                        );
                        mediaFiles.add(pm);
                      }
                      if (mediaFiles.length > 0) {
                        PostController.createPost(mediaFiles,
                            postCaptionController.text, post_type, context);
                      } else {
                        Values.showMsgDialog(
                            "New Post", "Please select post media", context,
                            () {
                          Navigator.of(context).pop();
                        });
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: const Text("Create Post")),
              )
            ],
          ),
        )
      ],
    );
  }
}
