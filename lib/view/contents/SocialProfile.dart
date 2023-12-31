import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/controllers/socialprofilecontroller.dart';
import 'package:univ_app/utility/values.dart';
import 'package:univ_app/view/contents/UserCertificates.dart';
import 'package:univ_app/view/contents/UserPerformance.dart';
import 'package:univ_app/view/contents/UserPhotosGallery.dart';
import 'package:univ_app/view/contents/UserVideosGallery.dart';

import 'package:image_picker/image_picker.dart';

class SocialProfile extends StatefulWidget {
  @override
  State<SocialProfile> createState() => _SocialProfileState();
}

class _SocialProfileState extends State<SocialProfile>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;
  late TabController tabController;
  int _selectedIndex = 0;
  SocialProfileController socialProfileController =
      Get.put(SocialProfileController());

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        _selectedIndex = tabController.index;
      });
    });
    super.initState();
  }

  Widget _getTabAtIndex() {
    var list = [
      UserPhotosGallery(), // FIRST ITEM
      UserVideosGallery(), // SECOND ITEM
      UserCertificates(), // THIRD ITEM
    ];
    return list[_selectedIndex];
  }

  final _imagePicker = ImagePicker();

  XFile? _imageFile, _videoFile;
  bool uploaded = false;

  Future<bool> _pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
      bool status = await uploadFile('image');
      if (status) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Successful'),
              content: const Text('The file was uploaded successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.offAllNamed("/social_profile"); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Failed'),
              content: const Text("File upload failed."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    return false;
  }

  Future<bool> _pickProfileImage() async {
    setState(() {
      _isLoading = true;
    });
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
      bool status = await uploadProfilePic();
      if (status) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Successful'),
              content: const Text('The file was uploaded successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.offAllNamed("/social_profile"); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Failed'),
              content: const Text("File upload failed."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    return false;
  }

  Future<bool> _pickVideo() async {
    final pickedImage =
        await _imagePicker.pickVideo(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
      bool status = await uploadVideoFile('video_file');
      if (status) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Successful'),
              content: const Text('The file was uploaded successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.offAllNamed("/social_profile"); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Failed'),
              content: const Text("File upload failed."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    return false;
  }

  Future<bool> uploadFile(String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = await prefs.getInt("id");
      String? _token = await prefs.getString("token");
      if (_imageFile == null) {
        setState(() {
          _isLoading = false;
        });
        return false;
      }

      Uri url = Uri.parse("${Values.userImageUpload}?user_id=${id}");
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $_token';
      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        type,
        _imageFile!.path,
      ));

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        return true;
      } else {
        // Handle the error
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> uploadVideoFile(String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = await prefs.getInt("id");
      String? _token = await prefs.getString("token");
      if (_imageFile == null) {
        // No file selected, handle this as needed
        return false;
      }

      Uri url = Uri.parse("${Values.uploadUserVideos}?user_id=${id}");
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $_token';
      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        type,
        _imageFile!.path,
      ));

      // Send the request
      var response = await request.send();
      if (response.statusCode == 200) {
        // File uploaded successfully
        setState(() {
          _isLoading = false;
        });
        return true;
      } else {
        // Handle the error
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> uploadProfilePic() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = await prefs.getInt("id");
      String? _token = await prefs.getString("token");
      if (_imageFile == null) {
        // No file selected, handle this as needed
        return false;
      }

      Uri url = Uri.parse("${Values.profilePicUpload}?user_id=${id}");
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $_token';
      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _imageFile!.path,
      ));

      // Send the request
      var response = await request.send();
      if (response.statusCode == 200) {
        // File uploaded successfully
        var _response = await response.stream.bytesToString();
        var decoded_resp = jsonDecode(_response);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("image", decoded_resp['image']);
        setState(() {
          _isLoading = false;
        });
        return true;
      } else {
        // Handle the error
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> _pickCertificate() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
      bool status = await uploadCertificate('image');
      if (status) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Successful'),
              content: const Text('The file was uploaded successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.offAllNamed("/social_profile"); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Failed'),
              content: const Text("File upload failed."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    return false;
  }

  Future<bool> uploadCertificate(String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? id = await prefs.getInt("id");
      String? _token = await prefs.getString("token");
      if (_imageFile == null) {
        setState(() {
          _isLoading = false;
        });
        return false;
      }

      Uri url = Uri.parse("${Values.userImageUpload}?user_id=${id}&type=3");
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $_token';
      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        type,
        _imageFile!.path,
      ));

      // Send the request
      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        return true;
      } else {
        // Handle the error
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin:
                const EdgeInsets.only(left: 0, top: 10, right: 10, bottom: 0),
            child: _isLoading
                ? Container(
                    color: Colors.white.withOpacity(0.2),
                    child: const Center(
                        child:
                            CircularProgressIndicator())) // Show progress indicator when loading
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 30,
                          ))
                    ],
                  ),
          ),
        ),
        GetBuilder<SocialProfileController>(
          assignId: true,
          builder: (logic) {
            return SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, top: 5, right: 10, bottom: 10),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.black,
                              child: InkWell(
                                onTap: () {
                                  _pickProfileImage();
                                },
                                child: CircleAvatar(
                                    radius: 50,
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    backgroundImage: CachedNetworkImageProvider(
                                        Values.profilePic + logic.profilePic)),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 0, top: 5, right: 0, bottom: 0),
                                child: Column(
                                  children: [
                                    Text(logic.profileName,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    InkWell(
                                        onTap: () {
                                          Get.offAllNamed("/user_profile");
                                        },
                                        child: Text("Edit",style: TextStyle(color:Values.primaryColor ,fontSize: 16),))
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 5, top: 0, right: 20, bottom: 0),
                              child: const Column(
                                children: [
                                  Text("Following",
                                      style: TextStyle(
                                        color: Values.primaryColor,
                                        fontSize: 18,
                                      )),
                                  Text("0",
                                      style: TextStyle(
                                        color: Values.primaryColor,
                                        fontSize: 18,
                                      )),
                                ],
                              )),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 10, top: 1, right: 20, bottom: 0),
                              child: const Column(
                                children: [
                                  Text("Followers",
                                      style: TextStyle(
                                        color: Values.primaryColor,
                                        fontSize: 18,
                                      )),
                                  Text("0",
                                      style: TextStyle(
                                        color: Values.primaryColor,
                                        fontSize: 18,
                                      )),
                                ],
                              ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                          width: 150,
                          child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Alert Dialog Title'),
                                      content: const Text(
                                          'Are you sure you want to logout ?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            logic.logout(); // Close the dialog
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text("LOGOUT"))),
                    ],
                  )
                ],
              ),
            );
          },
        ),
        GetBuilder<SocialProfileController>(
            assignId: true,
            builder: (logic) {
              return SliverToBoxAdapter(
                child: Container(
                    margin: const EdgeInsets.only(
                        left: 10, top: 10, right: 8, bottom: 5),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(logic.about,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          )),
                    )),
              );
            }),
        SliverToBoxAdapter(
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                tabs: const [
                  Tab(
                    text: 'Photo',
                  ),
                  Tab(
                    text: 'Video',
                  ),
                  Tab(
                    text: 'Certificates',
                  ),
                ],
                labelColor: Colors.black,
                indicatorColor: Colors.green,
              ),
            ],
          ),
        ),
        _getTabAtIndex(),
      ],
    );
  }

  final List<String> items = ["Add Photos", "Add Videos", "Add Certificates"];

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext builder) {
        return FractionallySizedBox(
          heightFactor: 0.25,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 24,
                    )),
              ],
            ),
            Divider(
              height: 20,
              thickness: 2,
              color: const Color.fromRGBO(26, 188, 156, 70),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                });
                _pickImage();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add Photos", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                });
                _pickVideo();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add Videos", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                });
                _pickCertificate();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add Certificates", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}
