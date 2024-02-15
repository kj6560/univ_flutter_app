import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/usercertificatescontroller.dart';
import 'package:univ_app/utility/values.dart';
import 'package:image_picker/image_picker.dart';

class UserCertificates extends StatelessWidget {
  UserCertificatesController userCertificatesController =
      Get.put(UserCertificatesController());
  var _isLoading = false;
  final _imagePicker = ImagePicker();

  XFile? _imageFile;

  Future<bool> _pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _imageFile = pickedImage;
      return await userCertificatesController.uploadCertificate(
          'image', _imageFile);
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
                  crossAxisCount: 2,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding: const EdgeInsets.all(1),
                                  content: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        maxWidth: 400, maxHeight: 400),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      // Adjust the fit based on your requirement
                                      imageUrl: Values.userGallery +
                                          logic.userFiles[index].filePath,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                context: context,
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              color: Colors.grey,
                              child: CachedNetworkImage(
                                height: 150,
                                fit: BoxFit.cover,
                                imageUrl: Values.userGallery +
                                    logic.userFiles[index].filePath,
                                // URL of the image
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 3.0),
                                ),
                                // Placeholder widget
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error), // Error widget
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: IconButton(
                                  onPressed: () {
                                    showPostModal(logic.userFiles[index].id,
                                        context, logic);
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.ellipsisVertical,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  childCount: logic.userFiles
                      .length, // Replace this with the number of items you want
                ),
              )
            : SliverToBoxAdapter(
                child: InkWell(
                  onTap: () async {
                    var status = await _pickImage();
                    userCertificatesController.showMessage(status, context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Icon(Icons.add), Text("Add Certificates")],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  void showPostModal(
      int id, BuildContext context, UserCertificatesController logic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext builder) {
        return FractionallySizedBox(
          heightFactor: 0.3,
          child: Column(children: [
            Column(
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Post Options",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const Divider(
              height: 2,
              thickness: 2,
              color: Values.primaryColor,
            ),
            InkWell(
                onTap: () {
                  logic.archiveUserFile(id);
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Center(
                    child: Text(
                      "Archive Certificates",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ]),
        );
      },
    );
  }
}
