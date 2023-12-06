import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/usercertificatescontroller.dart';
import 'package:univ_app/controllers/userphotoscontroller.dart';
import 'package:univ_app/utility/values.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UserCertificates extends StatefulWidget {
  const UserCertificates({super.key});

  @override
  State<UserCertificates> createState() => _UserCertificatesState();
}

class _UserCertificatesState extends State<UserCertificates> {
  UserCertificatesController userCertificatesController =
      Get.put(UserCertificatesController());
  var _isLoading = false;
  final _imagePicker = ImagePicker();

  XFile? _imageFile;

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
    }else{
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
    return GetX<UserCertificatesController>(
      builder: (logic) {
        return logic.userFiles.length > 0
            ? SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        color: Colors.grey,
                        child: InkWell(
                            onTap: () {
                              showDialog(
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding: EdgeInsets.all(1),
                                  content: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: 400, maxHeight: 400),
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
                                child:
                                    CircularProgressIndicator(strokeWidth: 3.0),
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
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: const Text("Add Certificates"),
                    onTap: () {
                      setState(() {
                        _isLoading = true;
                      });
                      _pickImage();
                    },
                  )
                ],
              );
      },
    );
  }
}
