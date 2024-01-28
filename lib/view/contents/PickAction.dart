import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:univ_app/controllers/postcontroller.dart';
import 'package:univ_app/models/post.dart';
import 'package:univ_app/services/remote_services.dart';

class PickAction extends StatefulWidget {
  @override
  State<PickAction> createState() => _PickActionState();
}

class _PickActionState extends State<PickAction>
    with SingleTickerProviderStateMixin {
  String selectedPostType = 'Post';
  List<String> options = ['Post', 'Video', 'Story'];
  List<XFile> _imageFile = [];
  TextEditingController postCaptionController = TextEditingController();
  int post_type = 1;

  Future<void> _fetchGalleryImages() async {
    await ImagePicker().pickMultiImage().then((value) {
      setState(() {
        _imageFile = value ?? [];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchGalleryImages();
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
                          Radio(
                            value: option,
                            groupValue: selectedPostType,
                            onChanged: (value) {
                              setState(() {
                                selectedPostType = value as String;
                              });

                              if(selectedPostType == "Post"){
                                post_type = 1;
                              }else if(selectedPostType == "Video"){
                                post_type = 2;
                              }else if(selectedPostType == "Story"){
                                post_type  = 3;
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
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 0.0,
          ),
          delegate: SliverChildListDelegate(
            _prepareMediaList(_imageFile),
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

                      List<PostMedia> mediaFiles = [];
                      int i=0;
                      _imageFile.map((imageFile) => (){
                        PostMedia pm = PostMedia(mediaName: imageFile.path, mediaType: 1, mediaPosition: ++i,path:imageFile.path);
                        mediaFiles.add(pm);
                      });
                      PostController.createPost(mediaFiles, postCaptionController.text,post_type);
                    }, child: const Text("Create Post")),
              )
            ],
          ),
        )
      ],
    );
  }
}