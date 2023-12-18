import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:univ_app/controllers/userprofilecontroller.dart';
import 'package:univ_app/utility/values.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String selectedOption = 'Male', selectedMarriedOption = 'Married';
  DateTime selectedDate = DateTime.now(); // Track selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Initial date set to selectedDate
      firstDate: DateTime(1950), // Limit start date
      lastDate: DateTime(2024), // Limit end date
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Update selectedDate if a date is picked
      });
    }
  }

  UserProfileController _userProfileController =
      Get.put(UserProfileController());
  final _imagePicker = ImagePicker();
  XFile? _imageFile;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  var _isLoading = false;

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
      setState(() {
        _isLoading = false;
      });
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
                    Get.offAllNamed("/user_profile"); // Close the dialog
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
  void initState() {
    // Called when the state object is first created
    // Put initialization logic here
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(
      assignId: true,
      builder: (logic) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _isLoading
                      ? Container(
                          color: Colors.white.withOpacity(0.2),
                          child: const Center(
                              child:
                                  CircularProgressIndicator())) // Show progress indicator when loading
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
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
                                      '${Values.profilePic}${logic.image}'),),
                            ),
                          ),
                        ),
                  const Text("Edit profile picture")
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 30.0, bottom: 10.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Contact Details',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: const EdgeInsets.all(20.0),
                          // Adding padding inside the box
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            // Adding border around the box
                            borderRadius: BorderRadius.circular(
                                8.0), // Adding rounded corners
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                  controller: firstNameController
                                    ..text = logic.first_name,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
//hintText: 'Tell us about yourself',
                                      helperText: 'Your First Name',
                                      labelText: 'First Name',
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
//suffixText: 'USD',
                                      suffixStyle:
                                          TextStyle(color: Colors.green)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                  controller: lastNameController
                                    ..text = logic.last_name,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
//hintText: 'Tell us about yourself',
                                      helperText: 'Your Last Name',
                                      labelText: 'Last Name',
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
//suffixText: 'USD',
                                      suffixStyle:
                                          TextStyle(color: Colors.green)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                  controller: phoneController
                                    ..text = logic.number,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
//hintText: 'Tell us about yourself',
                                      helperText: 'Your Phone Number',
                                      labelText: 'Number',
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
//suffixText: 'USD',
                                      suffixStyle:
                                          TextStyle(color: Colors.green)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                  controller: emailController
                                    ..text = logic.email,
                                  enabled: false,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
//hintText: 'Tell us about yourself',
                                      helperText: 'Your Email Address',
                                      labelText: 'Email',
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
//suffixText: 'USD',
                                      suffixStyle:
                                          TextStyle(color: Colors.green)),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 30.0, bottom: 10.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Personal Details',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: const EdgeInsets.all(20.0),
                          // Adding padding inside the box
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            // Adding border around the box
                            borderRadius: BorderRadius.circular(
                                8.0), // Adding rounded corners
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                  controller: heightController
                                    ..text = logic.height,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
                                      hintText:
                                          'Tell us your height in centimeters',
                                      helperText: 'Your Height',
                                      labelText: 'Height',
                                      prefixIcon: Icon(
                                        Icons.accessibility,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
//suffixText: 'USD',
                                      suffixStyle:
                                          TextStyle(color: Colors.green)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                  controller: weightController
                                    ..text = logic.weight,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
                                      hintText: 'Tell us your weight in Kg',
                                      helperText: 'Your Weight',
                                      labelText: 'Weight',
                                      prefixIcon: Icon(
                                        Icons.monitor_weight,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
//suffixText: 'USD',
                                      suffixStyle:
                                          TextStyle(color: Colors.green)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  // Adding padding inside the box
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    // Adding border around the box
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Adding rounded corners
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Maritial Status"),
                                          ],
                                        ),
                                      ),
                                      RadioListTile<String>(
                                        title: const Text('Married'),
                                        value: 'Married',
                                        // Value for Female option
                                        groupValue: selectedMarriedOption,
                                        // Current selected option
                                        onChanged: (value) {
                                          setState(() {
                                            selectedMarriedOption = value!;
                                          });
                                        },
                                        selected: logic.married == 1,
                                      ),
                                      RadioListTile<String>(
                                        title: const Text('UnMarried'),
                                        value: 'UnMarried',
                                        // Value for Male option
                                        groupValue: selectedMarriedOption,
                                        // Current selected option
                                        onChanged: (value) {
                                          setState(() {
                                            selectedMarriedOption = value!;
                                          });
                                        },
                                        selected: logic.married == 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  // Adding padding inside the box
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    // Adding border around the box
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Adding rounded corners
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Gender"),
                                          ],
                                        ),
                                      ),
                                      RadioListTile<String>(
                                        title: const Text('Female'),
                                        value: 'Female',

                                        // Value for Female option
                                        groupValue: selectedOption,
                                        // Current selected option
                                        onChanged: (value) {
                                          setState(() {
                                            selectedOption = value!;
                                          });
                                        },
                                        selected: logic.gender == 2,
                                      ),
                                      RadioListTile<String>(
                                          title: const Text('Male'),
                                          value: 'Male',
                                          // Value for Male option
                                          groupValue: selectedOption,
                                          // Current selected option
                                          onChanged: (value) {
                                            setState(() {
                                              selectedOption = value!;
                                            });
                                          },
                                          selected: logic.gender == 1),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                  controller: bioController..text = logic.about,
                                  maxLines: null,
                                  // Setting maxLines to null allows multiple lines
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
                                      hintText:
                                          'Describe yourself in 250 chars',
                                      helperText: 'Tell us about yourself',
                                      labelText: 'Bio',
                                      prefixIcon: Icon(
                                        Icons.info,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
//suffixText: 'USD',
                                      suffixStyle:
                                          TextStyle(color: Colors.green)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    // Adding border around the box
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Adding rounded corners
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [Text("Date of Birth")],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    _selectDate(context),
                                                child: Text('Select'),
                                              ),
                                            ),
                                            Text(
                                              'Date Of Birth: ${logic.birthday != null && logic.birthday != "" ? logic.birthday.substring(0, 10) : selectedDate.toString().substring(0, 10)}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 30.0, bottom: 10.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Address Details',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: const EdgeInsets.all(20.0),
                          // Adding padding inside the box
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            // Adding border around the box
                            borderRadius: BorderRadius.circular(
                                8.0), // Adding rounded corners
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                  controller: addressController
                                    ..text = logic.address_line1,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
//hintText: 'Tell us about yourself',
                                      helperText: 'Your Street address',
                                      labelText: 'Address Line 1',
                                      prefixIcon: Icon(
                                        Icons.location_on,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
//suffixText: 'USD',
                                      suffixStyle:
                                          TextStyle(color: Colors.green)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                  controller: cityController..text = logic.city,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
//hintText: 'Tell us about yourself',
                                      helperText: 'Your City',
                                      labelText: 'city',
                                      prefixIcon: Icon(
                                        Icons.location_city,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
//suffixText: 'USD',
                                      suffixStyle:
                                          TextStyle(color: Colors.green)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                  controller: stateController
                                    ..text = logic.state,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
//hintText: 'Tell us about yourself',
                                      helperText: 'Your State',
                                      labelText: 'State',
                                      prefixIcon: Icon(
                                        Icons.location_city_outlined,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
//suffixText: 'USD',
                                      suffixStyle:
                                          TextStyle(color: Colors.green)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                  controller: pincodeController
                                    ..text = logic.pincode,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
//hintText: 'Tell us about yourself',
                                      helperText: 'Your Postal Code',
                                      labelText: 'Pincode',
                                      prefixIcon: Icon(
                                        Icons.pin,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
//suffixText: 'USD',
                                      suffixStyle:
                                          TextStyle(color: Colors.green)),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, bottom: 25.0),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      _userProfileController.updateProfile(
                          firstNameController.text.toString(),
                          lastNameController.text.toString(),
                          bioController.text.toString(),
                          phoneController.text.toString(),
                          selectedOption.contains('Female') ? 2 : 1,
                          selectedMarriedOption.contains('UnMarried') ? 2 : 1,
                          heightController.text.toString(),
                          weightController.text.toString(),
                          addressController.text.toString(),
                          cityController.text.toString(),
                          stateController.text.toString(),
                          pincodeController.text.toString(),
                          selectedDate,
                          context);
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: const Text("Update")),
              ),
            )
          ],
        );
      },
    );
  }
}
