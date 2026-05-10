import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class LocalStorageService {
  Future<void> persistPrototypeState();
  Future<void> writeSecureValue(String key, String value);
  Future<String?> readSecureValue(String key);
  Future<void> deleteSecureValue(String key);
}

class PrototypeLocalStorageService implements LocalStorageService {
  PrototypeLocalStorageService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> persistPrototypeState() async {}

  @override
  Future<void> deleteSecureValue(String key) {
    return _secureStorage.delete(key: key);
  }

  @override
  Future<String?> readSecureValue(String key) {
    return _secureStorage.read(key: key);
  }

  @override
  Future<void> writeSecureValue(String key, String value) {
    return _secureStorage.write(key: key, value: value);
  }
}
