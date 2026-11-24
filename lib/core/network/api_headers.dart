import 'package:lms/core/storage/local_storage.dart';
import 'package:lms/core/storage/local_storage_keys.dart';

class ApiHeaders {
  static Map<String, String> headerWithContentTypeJsonOnly() {
    return {
      "Content-Type": "application/json",
      "ngrok-skip-browser-warning": "true",
    };
  }

  static Map<String, String> headerWithTokenAndContentTypeJsonOnly() {
    return {
      "Content-Type": "application/json",
      "ngrok-skip-browser-warning": "true",
      "Authorization":
          "Bearer ${LocalStorage.getData(key: LocalStorageKeys.accessTokenKey)}",
    };
  }
}
