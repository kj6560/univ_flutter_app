import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/userperformancecontroller.dart';

class UserPerformance extends StatefulWidget {
  @override
  State<UserPerformance> createState() => _UserPerformanceState();
}

class _UserPerformanceState extends State<UserPerformance> {
  UserPerformanceController _userPerformanceController =
      Get.put(UserPerformanceController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserPerformanceController>(builder: (logic) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            // Replace this with your custom list item widget.
            return Card(
              child: _children(logic.performanceData)
              );
          },
          childCount: logic.performanceData.length, // Number of list items
        ),
      );
    });
  }

  _children(var data) {
    List<Widget> children = []; // Define List<Widget>
    data.forEach((dynamicModel) {
      dynamicModel.data.forEach((key, value) {
        children.add(
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(key,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                Text(value!=null?value:"")
              ],
          ),
           ),
        );
      });
    });


    // Now, use the children list within a Column widget
    // For example, assuming it's inside the build method
    return Column(
      children: children,
    );
  }


}
