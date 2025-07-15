import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Service for local data persistence using GetStorage
class StorageService extends GetxService {
  late GetStorage _box;

  @override
  Future<void> onInit() async {
    super.onInit();
    _box = GetStorage();
  }

  /// Save data to local storage
  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// Read data from local storage
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// Remove data from local storage
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// Clear all data
  Future<void> clear() async {
    await _box.erase();
  }

  /// Check if key exists
  bool hasData(String key) {
    return _box.hasData(key);
  }
}