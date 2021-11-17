import 'package:flutter/material.dart';
import 'package:yim2/yim2.dart';

abstract class YimUser extends YimModel {}

abstract class YimLoginUser<T extends YimUser> extends ChangeNotifier {
  static const String __tokenDataKey = "__tokenDataKey";
  static const String __userInfoDataKey = "__userInfoDataKey";

  T? _user;
  String? _token;
  T? get user => _user;
  String? get token => _token;
  void customNotify() => notifyListeners();
  bool get isLogin => token != null;
  late YimDataPreferences _dataPreferences;

  Future init(YimDataPreferences dataPreferences) async {
    _dataPreferences = dataPreferences;
    _token = _dataPreferences.getString(__tokenDataKey);
    _user = _dataPreferences.getModel<T>(__userInfoDataKey, () => modelCreater());
    if (isLogin) syncUserInfoFromServer();
  }

  set user(T? value) => updateUser(value);

  Future updateUser(T? newUser, {bool notify = false}) async {
    _user = newUser;
    _user == null ? await _dataPreferences.remove(__userInfoDataKey) : await _dataPreferences.setModel<T>(__userInfoDataKey, _user!);
    if (notify) notifyListeners();
  }

  void _updateToken(String? token, {bool notify = false}) {
    _token = token;
    _token == null ? _dataPreferences.remove(__tokenDataKey) : _dataPreferences.setString(__tokenDataKey, _token!);
    if (notify) notifyListeners();
  }

  Future loginWithToken(String token, {notify = true, bool syncServerUserInfo = true}) async {
    _updateToken(token);
    if (notify) notifyListeners();
    if (syncServerUserInfo) syncUserInfoFromServer();
  }

  Future loginWithTokenAndUser(String token, T user, {bool notify = true}) async {
    _updateToken(token);
    updateUser(user);
    if (notify) notifyListeners();
  }

  Future loginOut({bool notify = true}) async {
    await _dataPreferences.remove(__tokenDataKey);
    await _dataPreferences.remove(__userInfoDataKey);
    _token = null;
    _user = null;
    if (notify) notifyListeners();
  }

  Future syncUserInfoFromServer() async {
    var user = await getUserInfoFromServer();
    if (user != null) await updateUser(user);
  }

  Future<T?> getUserInfoFromServer();
  T modelCreater();
}
