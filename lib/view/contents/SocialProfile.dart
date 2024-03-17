import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/controllers/socialprofilecontroller.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';
import 'package:univ_app/view/contents/UserCertificates.dart';
import 'package:univ_app/view/contents/UserPostsGallery.dart';
import 'package:univ_app/view/contents/UserReelsGallery.dart';

import 'package:image_picker/image_picker.dart';

import '../../models/user.dart';

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
  late User? user;
  int current_user_id = 0;

  @override
  void initState() {
    // TODO: implement initState
    setCurrentUser();
    user = Get.arguments;
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        _selectedIndex = tabController.index;
      });
    });
    super.initState();
    RemoteServices.showSnackBar(context);
  }

  setCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      current_user_id = prefs.getInt("id")!;
    });
  }

  Widget _getTabAtIndex() {
    var list = [
      UserPostsGallery(
        socialProfileController: socialProfileController,
        isCurrentUser:
            user == null || user!.id == current_user_id ? true : false,
      ),
      // FIRST ITEM
      UserReelsGallery(
        socialProfileController: socialProfileController,
        isCurrentUser:
            user == null || user!.id == current_user_id ? true : false,
      ),
      // SECOND ITEM
      UserCertificates(
        isCurrentUser:
            user == null || user!.id == current_user_id ? true : false,
      ),
      // THIRD ITEM
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
                const EdgeInsets.only(left: 0, top: 5, right: 10, bottom: 0),
            child: _isLoading
                ? Container(
                    color: Values.primaryColor.withOpacity(0.2),
                    child: const Center(
                        child:
                            CircularProgressIndicator())) // Show progress indicator when loading
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (user == null) {
                              _showBottomSheet(context);
                            }
                          },
                          icon: const Icon(
                            FontAwesomeIcons.ellipsisVertical,
                            size: 18,
                          ))
                    ],
                  ),
          ),
        ),
        GetBuilder<SocialProfileController>(
          assignId: true,
          builder: (logic) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 5, top: 5, right: 0, bottom: 0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 42,
                                backgroundColor: Colors.black,
                                child: user == null
                                    ? InkWell(
                                        onTap: () {
                                          _pickProfileImage();
                                        },
                                        child: CircleAvatar(
                                            radius: 40,
                                            foregroundColor: Colors.black,
                                            backgroundColor: Colors.white,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    Values.profilePic +
                                                        logic.profilePic)),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.white,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                Values.profilePic +
                                                    logic.profilePic)),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 0, top: 5, right: 0, bottom: 0),
                                  child: Column(
                                    children: [
                                      Text(logic.profileName,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      user == null ||
                                              user!.id == current_user_id
                                          ? InkWell(
                                              onTap: () {
                                                Get.toNamed(
                                                    "/user_profile");
                                              },
                                              child: const Text(
                                                "Edit",
                                                style: TextStyle(
                                                    color: Values.primaryColor,
                                                    fontSize: 16),
                                              ))
                                          : const SizedBox(
                                              height: 1,
                                            )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                //posts
                                Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, top: 0, right: 10, bottom: 0),
                                    child: Column(
                                      children: [
                                        Text("${logic.posts}",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            )),
                                        const Text("Posts",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            )),
                                      ],
                                    )),
                                //following
                                Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, top: 0, right: 10, bottom: 0),
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed("/followings",
                                            arguments: user);
                                      },
                                      child: Column(
                                        children: [
                                          Text("${logic.following}",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              )),
                                          const Text("Following",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                    )),
                                //followers
                                Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, top: 0, right: 10, bottom: 0),
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed("/followers",
                                            arguments: user);
                                      },
                                      child: Column(
                                        children: [
                                          Text("${logic.followers}",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              )),
                                          const Text("Followers",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                            const SizedBox(height: 1),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        GetBuilder<SocialProfileController>(
            assignId: true,
            builder: (logic) {
              return SliverToBoxAdapter(
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                      child: Text(logic.about,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          )),
                    )),
              );
            }),
        user != null && current_user_id != user!.id
            ? GetBuilder<SocialProfileController>(builder: (logic) {
                return SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              showFollowModal(logic, context);
                            },
                            child: Text(
                              logic.followed == 1 ? "FOLLOWED" : "FOLLOW",
                            )),
                        SizedBox(
                            width: 150,
                            child: ElevatedButton(
                                onPressed: () {}, child: const Text("Message")))
                      ],
                    ),
                  ),
                );
              })
            : const SliverToBoxAdapter(
                child: SizedBox(
                  height: 0,
                ),
              ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(
                      text: 'Posts',
                    ),
                    Tab(
                      text: 'Reels',
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
        ),
        _getTabAtIndex(),
      ],
    );
  }

  final List<String> items = ["Add Posts", "Add Certificates"];

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext builder) {
        return FractionallySizedBox(
          heightFactor: 0.3,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.circleXmark,
                      size: 30,
                    )),
              ],
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.white,
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Values.primaryColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Add Posts",
                              style: TextStyle(fontSize: 16))),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Get.offAllNamed("/new");
              },
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
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Values.primaryColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Add Certificates", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            user == null
                ? InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: Values.primaryColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Logout", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Logout'),
                            content:
                                const Text('Are you sure you want to logout ?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  socialProfileController
                                      .logout(); // Close the dialog
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
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ]),
        );
      },
    );
  }

  void showFollowModal(SocialProfileController logic, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext builder) {
        return FractionallySizedBox(
          heightFactor: 0.3,
          child: Column(children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: SizedBox(
                        height: 5,
                        width: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.white,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                });
                if (user != null) {
                  if (logic.followed != 1) {
                    logic.followUser(user!.id, context);
                  } else {
                    logic.unfollowUser(user!.id, context);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: logic.followed != 1
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Values.primaryColor)),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Follow ${logic.profileName}",
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Values.primaryColor)),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("UnFollow ${logic.profileName}",
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
              ),
            ),
          ]),
        );
      },
    );
  }
}
