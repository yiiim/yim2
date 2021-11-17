import 'package:shared_preferences/shared_preferences.dart';
import 'package:yim2/model.dart';

abstract class YimDataPreferences {
  static Future<YimDataPreferences> getInstance() => _DefaultYimDataPreferences.getInstance();
  Object? get(String key);
  Set<String> getKeys();
  bool? getBool(String key);
  int? getInt(String key);
  double? getDouble(String key);
  String? getString(String key);
  bool containsKey(String key);
  List<String>? getStringList(String key);
  Future<bool> setBool(String key, bool value);
  Future<bool> setInt(String key, int value);
  Future<bool> setDouble(String key, double value);
  Future<bool> setString(String key, String value);
  Future<bool> setStringList(String key, List<String> value);
  Future<bool> remove(String key);
  Future<bool> clear();
  Future<void> reload();
  //custom methods
  T? getModel<T extends YimModel>(String key, T Function() modelBuilder) {
    if (!containsKey(key)) return null;
    String stringValue = getString(key)!;
    return modelBuilder()..initWithJsonString(stringValue);
  }

  void fillUpModel<T extends YimModel>(String key, T model) {
    if (!containsKey(key)) return;
    String stringValue = getString(key)!;
    model.initWithJsonString(stringValue);
  }

  Future<bool> setModel<T extends YimModel>(String key, T value) => setString(key, value.toJson());

  List<T>? getModelList<T extends YimModel>(String key, T Function() modelBuilder) {
    if (!containsKey(key)) return null;
    List<String> stringValue = getStringList(key)!;
    return stringValue.map((e) => modelBuilder()..initWithJsonString(e)).toList();
  }

  Future<bool> setModelList<T extends YimModel>(String key, List<T> value) => setStringList(key, value.map((e) => e.toJson()).toList());
}

class _DefaultYimDataPreferences extends YimDataPreferences {
  static Future<_DefaultYimDataPreferences> getInstance() async {
    return _DefaultYimDataPreferences().._sharedPreferences = await SharedPreferences.getInstance();
  }

  late SharedPreferences _sharedPreferences;
  @override
  Future<bool> clear() => _sharedPreferences.clear();

  @override
  bool containsKey(String key) => _sharedPreferences.containsKey(key);

  @override
  bool? getBool(String key) => _sharedPreferences.getBool(key);

  @override
  double? getDouble(String key) => _sharedPreferences.getDouble(key);

  @override
  int? getInt(String key) => _sharedPreferences.getInt(key);

  @override
  Set<String> getKeys() => _sharedPreferences.getKeys();

  @override
  String? getString(String key) => _sharedPreferences.getString(key);

  @override
  List<String>? getStringList(String key) => _sharedPreferences.getStringList(key);

  @override
  Future<void> reload() => _sharedPreferences.reload();

  @override
  Future<bool> remove(String key) => _sharedPreferences.remove(key);

  @override
  Future<bool> setBool(String key, bool value) => _sharedPreferences.setBool(key, value);

  @override
  Future<bool> setDouble(String key, double value) => _sharedPreferences.setDouble(key, value);

  @override
  Future<bool> setInt(String key, int value) => _sharedPreferences.setInt(key, value);

  @override
  Future<bool> setString(String key, String value) => _sharedPreferences.setString(key, value);

  @override
  Future<bool> setStringList(String key, List<String> value) => _sharedPreferences.setStringList(key, value);

  @override
  Object? get(String key) => _sharedPreferences.get(key);
}
