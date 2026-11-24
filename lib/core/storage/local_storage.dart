import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final GetStorage _box = GetStorage();

  static String saveData({required String key, required String dataToSave}) {
    _box.write(key, dataToSave);
    return key;
  }

  static String getData({required String key}) {
    return _box.read(key) ?? '';
  }

  static Future<void> deleteData({required String key}) async {
    await _box.remove(key);
  }

  static Future<void> clearAll() async {
    await _box.erase();
  }
}
