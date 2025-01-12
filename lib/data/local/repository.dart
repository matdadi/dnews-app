import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStorageKey { token, email, username, userDisplay }

extension SecureStorageKeyExtension on SecureStorageKey {
  String get key {
    switch (this) {
      case SecureStorageKey.token:
        return dotenv.get('TOKEN_KEY');
      case SecureStorageKey.email:
        return dotenv.get('EMAIL_KEY');
      case SecureStorageKey.username:
        return dotenv.get('USERNAME_KEY');
      case SecureStorageKey.userDisplay:
        return dotenv.get('USER_DISPLAY_KEY');
    }
  }
}

class Repository {
  final _secureStorage = const FlutterSecureStorage();

  IOSOptions _iosOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  AndroidOptions _androidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> save(SecureStorageKey key, String value) async {
    await _secureStorage.write(
      key: key.key,
      value: value,
      iOptions: _iosOptions(),
      aOptions: _androidOptions(),
    );
  }

  Future<String?> get(SecureStorageKey key) async {
    return await _secureStorage.read(
      key: key.key,
      iOptions: _iosOptions(),
      aOptions: _androidOptions(),
    );
  }

  Future<void> remove(SecureStorageKey key) async {
    await _secureStorage.delete(
      key: key.key,
      iOptions: _iosOptions(),
      aOptions: _androidOptions(),
    );
  }
}
