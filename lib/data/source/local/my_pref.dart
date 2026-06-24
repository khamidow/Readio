import 'package:shared_preferences/shared_preferences.dart';

class MyPref {
  static late final SharedPreferences _myPref;

  static Future<void> init() async {
    _myPref = await SharedPreferences.getInstance();
  }

  static Future<bool> setText(String name, String value) async {
    return await _myPref.setString(name, value);
  }

  static String getText(String name) {
    return _myPref.getString(name) ?? 'NULL';
  }
}
