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
      return CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5.0,
                    child: _children(logic.performanceData),
                  ),
                );
              },
              childCount: logic.performanceData
                  .length, // Replace this with the number of items you want
            ),
          ),
        ],
      );
    });
  }

  _children(var data) {
    List<Widget> children = [];
    data.forEach((dynamicModel) {
      dynamicModel.data.forEach((key, value) {
        children.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  key,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(value != null ? value : "")
              ],
            ),
          ),
        );
      });
    });
    children = children.reversed.toList();
    return SingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }
}
