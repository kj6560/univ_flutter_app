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
          logic.performanceData.length > 0
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext ctxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.grey,
                      title:
                          Text(logic.performanceData[0].data.values.firstOrNull !="" ? logic.performanceData[0].data.values.firstOrNull:logic.performanceData[0].data.values.lastOrNull),
                      children: _children(logic.performanceData),
                    ),
                  );
                }, childCount: logic.performanceData.length))
              : const SliverToBoxAdapter(
                  child: Center(
                    child: Text("Performance data not available"),
                  ),
                )
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
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  key,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(value != null ? value : "")
              ],
            ),
          ),
        );
      });
    });
    children = children.reversed.toList();
    return children;
  }
}
