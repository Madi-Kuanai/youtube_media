import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_media/Consts.dart';

class PreferenceService {
  static SharedPreferences? _pref;

  static Future init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static bool checkFavourite(String key) {
    return _pref!.containsKey(key);
  }

  static deleteFavourite(String key) async {
    if (_pref!.containsKey(key)) await _pref!.remove(key);
  }

  static addFavourite(String key) async {
    await _pref!.setBool(key, true);
  }

  static getFavourites() {
    return _pref!.getKeys();
  }

  static getLastLocal() {
    return _pref!.get(Consts.lastLocal);
  }

  static setLastLocal(String local) async {
    await _pref!.setString(Consts.lastLocal, local);
    print(local);
  }
}
