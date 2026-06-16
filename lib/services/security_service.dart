import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servicio para manejar el almacenamiento seguro de datos sensibles.
class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyToken = 'auth_token';
  static const _keyLastSessionTime = 'last_session_time';

  /// Guarda el token de forma encriptada.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Recupera el token.
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Guarda el tiempo de la última sesión (o tiempo de cierre).
  Future<void> saveSessionTime(DateTime time) async {
    await _storage.write(key: _keyLastSessionTime, value: time.toIso8601String());
  }

  /// Recupera el tiempo de la última sesión.
  Future<DateTime?> getSessionTime() async {
    final value = await _storage.read(key: _keyLastSessionTime);
    if (value != null) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  /// Limpia los datos de sesión (si es necesario).
  Future<void> clearSession() async {
    // Nota: El usuario pidió guardar el token al cerrar, por lo que tal vez no queramos borrarlo todo.
    // Pero usualmente se borra al cerrar sesión de verdad.
    // Por ahora, solo proveemos el método por si se requiere.
  }
}
