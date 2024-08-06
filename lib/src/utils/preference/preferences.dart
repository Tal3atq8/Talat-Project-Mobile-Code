import 'package:shared_preferences/shared_preferences.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';

class SharedPref {
  static Future setBool(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future setListString(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(PreferenceConstants.recentSearchesKey, value);
  }

  static Future<List<String>> getListString(String recentSearchesKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> myList = prefs.getStringList(PreferenceConstants.recentSearchesKey) ?? [];
    return myList;
  }

  static Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static Future setString(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future setInt(String key, int val) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, val);
  }

  static Future<int> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static Future setDouble(String key, double val) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(key, val);
  }

  static Future<double> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 0.0;
  }

  static Future clearSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future removeSharedPref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
