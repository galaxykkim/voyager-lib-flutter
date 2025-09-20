import 'package:shared_preferences/shared_preferences.dart';

class VoyagerRepository {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> saveString({
    required String key,
    required String value,
  }) async =>
      (await _prefs).setString(key, value);

  Future<bool> saveInt({
    required String key,
    required int value,
  }) async =>
      (await _prefs).setInt(key, value);

  Future<bool> saveBool({
    required String key,
    required bool value,
  }) async =>
      (await _prefs).setBool(key, value);

  Future<String?> loadString({required String key}) async => (await _prefs).getString(key);

  Future<int?> loadInt({required String key}) async => (await _prefs).getInt(key);

  Future<bool?> loadBool({required String key}) async => (await _prefs).getBool(key);

  Future<bool?> remove({required String key}) async => (await _prefs).remove(key);

  Future<bool?> clear() async => (await _prefs).clear();
}