import 'package:shared_preferences/shared_preferences.dart';

class FavouritesPreference {
  static SharedPreferences? _pref;

  static Future init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static bool checkFavourite(String key) {
    return _pref!.containsKey(key);
  }

  static deleteFavourite(String key) async {
    if (_pref!.containsKey(key))  await _pref!.remove(key);
  }

  static addFavourite(String key) async {
    await _pref!.setBool(key, true);
  }
}
