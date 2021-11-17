import 'dart:convert';

import 'package:yim2/data.dart';

class YimModel {
  dynamic toEncodable() => {};
  String toJson() => jsonEncode(toEncodable());

  void initWithJsonString(String json) => initWithJsonObject(jsonDecode(json));
  void initWithJsonObject(Object jsonObject) {
    if (jsonObject is String) initWithJsonString(jsonObject);
    if (jsonObject is Map) initWithJsonMap(jsonObject);
  }

  void initWithJsonMap(Map jsonMap) {}
  String? jsonValueToString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  double? jsonValueToDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value * 1.0;
    return null;
  }

  List<T>? jsonValueToList<T>(dynamic value, {T Function(dynamic)? itemConvert}) {
    List<T> returnValue = [];
    List? dynamicListValue;
    if (value == null) return null;
    if (value is List) {
      dynamicListValue = value;
    } else {
      if (value is String) {
        try {
          var decode = jsonDecode(value);
          if (decode is List) dynamicListValue = decode;
        } catch (e) {}
      }
    }
    if (dynamicListValue != null) {
      if (itemConvert == null && "" is T) itemConvert = (e) => e.toString() as T;
      for (var item in dynamicListValue) {
        if (item is T) {
          returnValue.add(item);
        } else if (itemConvert != null) {
          returnValue.add(itemConvert(item));
        }
      }
      return returnValue;
    }
    return null;
  }
}

abstract class YimDataModel extends YimModel {
  String get dataKey;
  YimDataPreferences get dataPreferences;
  void init() => dataPreferences.fillUpModel(dataKey, this);
  void archiveDataModel() => dataPreferences.setModel(dataKey, this);
}
