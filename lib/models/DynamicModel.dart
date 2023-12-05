import 'dart:convert';

List<DynamicModel> dynamicModelFromJson(String str) =>
    List<DynamicModel>.from(json.decode(str).map((x) => DynamicModel.fromJson(x)));
class DynamicModel {
  final Map<dynamic, dynamic> data;

  DynamicModel(this.data);

  factory DynamicModel.fromJson(dynamic json) {
    assert(json is Map);
    return DynamicModel(json);
  }

}