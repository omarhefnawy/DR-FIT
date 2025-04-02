import 'package:shared_preferences/shared_preferences.dart';
class CacheHelper {

  //SharedPreferences
  static SharedPreferences? sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await sharedPreferences?.setString(key, value) ?? false;
    }
    if (value is int) {
      return await sharedPreferences?.setInt(key, value) ?? false;
    }
    if (value is bool) {
      return await sharedPreferences?.setBool(key, value) ?? false;
    }

    return await sharedPreferences!.setDouble(key, value);
  }

 static dynamic getData({required String key, dynamic defaultValue = false}) {
  if (sharedPreferences == null) {
    return defaultValue;
  }
  return sharedPreferences!.get(key) ?? defaultValue;
}


  static Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences!.remove(key);
  }
}
