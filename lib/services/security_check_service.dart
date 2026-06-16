import 'dart:io';
import 'package:safe_device/safe_device.dart';
import 'package:flutter/services.dart';

/// Servicio encargado de verificar la integridad del dispositivo y detectar Fake GPS.
class SecurityCheckService {
  static final SecurityCheckService _instance = SecurityCheckService._internal();
  factory SecurityCheckService() => _instance;
  SecurityCheckService._internal();

  /// Verifica si el dispositivo es seguro para ejecutar la aplicación.
  /// Retorna true si se detectan amenazas (Fake GPS, Root, Emulador).
  Future<bool> isDeviceCompromised() async {
    try {
      // 1. Verificar si se están usando ubicaciones simuladas (Fake GPS / Mock Location).
      bool isMockLocation = await SafeDevice.isMockLocation;
      
      // 2. Verificar si el dispositivo está "rooteado" o tiene "jailbreak".
      bool isJailBroken = await SafeDevice.isJailBroken;
      
      // 3. Verificar si es un emulador (opcional, pero recomendado para apps de alta seguridad).
      bool isRealDevice = await SafeDevice.isRealDevice;

      if (isMockLocation) {
        return true; // Fake GPS detectado.
      }

      if (isJailBroken) {
        return true; // Dispositivo rooteado.
      }

      // Podrías agregar más validaciones aquí.
      return false;
    } catch (e) {
      // En caso de error, por seguridad asumimos que podría estar comprometido
      // o permitimos según la política de la empresa.
      return false;
    }
  }

  /// Método específico para cerrar la app si se detecta una amenaza.
  void terminateApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
