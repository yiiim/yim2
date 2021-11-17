import 'dart:math';

import 'package:yim2/yim2.dart';

class YimLocationData extends YimModel {
  YimLocationData();
  factory YimLocationData.init(double latitude, double longitude) => (YimLocationData().._latitude = latitude).._longitude = longitude;
  factory YimLocationData.initWithJson(dynamic json) => YimLocationData()..initWithJsonObject(json);
  late double _latitude;
  late double _longitude;
  double get latitude => _latitude;
  double get longitude => _longitude;
  @override
  dynamic toEncodable() => {"latitude": latitude, "longitude": longitude};
  @override
  void initWithJsonMap(Map jsonMap) {
    _latitude = jsonValueToDouble(jsonMap["latitude"]) ?? 0.0;
    _longitude = jsonValueToDouble(jsonMap["longitude"]) ?? 0.0;
  }

  static const double _earthRadius = 6378.137; //地球半径
  double _rad(double d) => d * pi / 180.0;
  double distance(YimLocationData other) {
    double radLat1 = _rad(latitude);
    double radLat2 = _rad(other.latitude);
    double a = radLat1 - radLat2;
    double b = _rad(longitude) - _rad(other.longitude);
    double s = 2 * asin(sqrt(pow(sin(a / 2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    s = s * _earthRadius;
    s = (s * 10000).round() / 10000;
    return s;
  }
}

abstract class YimLocationResult extends YimModel {
  bool get locationServicesEnabled;
  bool get hasLocationPermission;
  bool get success;
  String get message;
  YimLocationData appleMapLocation();
  YimLocationData baiduMapLocation();
  YimLocationData googleMapLocation();
  YimLocationData gaodeMapLocation();
}

class YimNotOpenLocationServicesResult extends YimLocationResult {
  @override
  YimLocationData appleMapLocation() => throw UnimplementedError();

  @override
  YimLocationData baiduMapLocation() => throw UnimplementedError();

  @override
  YimLocationData gaodeMapLocation() => throw UnimplementedError();

  @override
  YimLocationData googleMapLocation() => throw UnimplementedError();

  @override
  bool get hasLocationPermission => throw UnimplementedError();

  @override
  bool get locationServicesEnabled => true;

  @override
  String get message => "未开启位置服务";

  @override
  bool get success => false;
}

class YimNoLocationPermissionResult extends YimLocationResult {
  @override
  YimLocationData appleMapLocation() => throw UnimplementedError();

  @override
  YimLocationData baiduMapLocation() => throw UnimplementedError();

  @override
  YimLocationData gaodeMapLocation() => throw UnimplementedError();

  @override
  YimLocationData googleMapLocation() => throw UnimplementedError();

  @override
  bool get hasLocationPermission => throw UnimplementedError();

  @override
  bool get locationServicesEnabled => false;

  @override
  String get message => "未开启位置权限";

  @override
  bool get success => false;
}

class YimSuccessLocationResult extends YimLocationResult {
  late YimLocationData _gcj02;
  late YimLocationData _bd09;
  late YimLocationData _wgs84;
  YimSuccessLocationResult();

  static const double _a = 6378245.0;
  static const double _ee = 0.00669342162296594323;
  static bool outOfChina(double lat, double lon) {
    if (lon < 72.004 || lon > 137.8347) return true;
    if (lat < 0.8293 || lat > 55.8271) return true;
    return false;
  }

  static YimLocationData transform(double lat, double lon) {
    if (outOfChina(lat, lon)) return YimLocationData.init(lat, lon);
    double dLat = transformLat(lon - 105.0, lat - 35.0);
    double dLon = transformLon(lon - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - _ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((_a * (1 - _ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (_a / sqrtMagic * cos(radLat) * pi);
    double mgLat = lat + dLat;
    double mgLon = lon + dLon;
    return YimLocationData.init(mgLat, mgLon);
  }

  static double transformLat(double x, double y) {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
  }

  static double transformLon(double x, double y) {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
  }

  static YimLocationData _gcj02ToBd09(double latitude, double longitude) {
    double x = longitude, y = latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * pi);
    double bdLongitude = z * cos(theta) + 0.0065;
    double bdLatitude = z * sin(theta) + 0.006;
    return YimLocationData.init(bdLatitude, bdLongitude);
  }

  static YimLocationData _gcj02ToWgs84(double latitude, double longitude) {
    YimLocationData gps = transform(latitude, longitude);
    double wgs84Lontitude = longitude * 2 - gps.longitude;
    double wgs84Latitude = latitude * 2 - gps.latitude;
    return YimLocationData.init(wgs84Latitude, wgs84Lontitude);
  }

  static YimLocationData _bd09ToGcj02(double latitude, double longitude) {
    double x = longitude - 0.0065, y = latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * pi);
    double ggLon = z * cos(theta);
    double ggLat = z * sin(theta);
    return YimLocationData.init(ggLat, ggLon);
  }

  static YimLocationData _bd09ToWgs84(double latitude, double longitude) {
    YimLocationData gcj02 = _bd09ToGcj02(latitude, longitude);
    YimLocationData map84 = _gcj02ToWgs84(gcj02.latitude, gcj02.longitude);
    return map84;
  }

  static YimLocationData _wgs84ToBd09(double latitude, double longitude) {
    YimLocationData gcj02 = _wgs84ToGcj02(latitude, longitude);
    YimLocationData bd09 = _gcj02ToBd09(gcj02.latitude, gcj02.longitude);
    return bd09;
  }

  static YimLocationData _wgs84ToGcj02(double latitude, double longitude) {
    if (outOfChina(latitude, longitude)) return YimLocationData.init(latitude, longitude);
    double dLat = transformLat(longitude - 105.0, latitude - 35.0);
    double dLon = transformLon(longitude - 105.0, latitude - 35.0);
    double radLat = latitude / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - _ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((_a * (1 - _ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (_a / sqrtMagic * cos(radLat) * pi);
    double mgLat = latitude + dLat;
    double mgLon = longitude + dLon;
    return YimLocationData.init(mgLat, mgLon);
  }

  factory YimSuccessLocationResult.fromGcj02(double latitude, double longitude) {
    YimSuccessLocationResult result = YimSuccessLocationResult();
    result._gcj02 = YimLocationData.init(latitude, longitude);
    result._bd09 = _gcj02ToBd09(latitude, longitude);
    result._wgs84 = _gcj02ToWgs84(latitude, longitude);
    return result;
  }
  factory YimSuccessLocationResult.fromBd09(double latitude, double longitude) {
    YimSuccessLocationResult result = YimSuccessLocationResult();
    result._bd09 = YimLocationData.init(latitude, longitude);
    result._gcj02 = _bd09ToGcj02(latitude, longitude);
    result._wgs84 = _bd09ToWgs84(latitude, longitude);
    return result;
  }
  factory YimSuccessLocationResult.fromWgs84(double latitude, double longitude) {
    YimSuccessLocationResult result = YimSuccessLocationResult();
    result._wgs84 = YimLocationData.init(latitude, longitude);
    result._gcj02 = _wgs84ToGcj02(latitude, longitude);
    result._bd09 = _wgs84ToBd09(latitude, longitude);
    return result;
  }
  @override
  YimLocationData appleMapLocation() => _gcj02;

  @override
  YimLocationData baiduMapLocation() => _bd09;

  @override
  YimLocationData gaodeMapLocation() => _gcj02;

  @override
  YimLocationData googleMapLocation() => _wgs84;

  @override
  bool get hasLocationPermission => true;

  @override
  bool get locationServicesEnabled => true;

  @override
  String get message => "";

  @override
  bool get success => true;

  @override
  dynamic toEncodable() => {
        "gcj02": _gcj02.toEncodable(),
        "bd09": _bd09.toEncodable(),
        "wgs84": _wgs84.toEncodable(),
      };

  @override
  void initWithJsonMap(Map jsonMap) {
    _gcj02 = YimLocationData.initWithJson(jsonMap["gcj02"]);
    _bd09 = YimLocationData.initWithJson(jsonMap["bd09"]);
    _wgs84 = YimLocationData.initWithJson(jsonMap["wgs84"]);
  }
}
