import 'dart:async';
import 'package:flutter/material.dart';
import 'security_service.dart';
import '../screens/login_screen.dart';

/// Clase que gestiona la inactividad del usuario y el cierre de sesión.
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  Timer? _inactivityTimer;
  
  // Tiempo de inactividad permitido (ejemplo: 5 minutos).
  static const Duration inactivityDuration = Duration(minutes: 5);

  final SecurityService _securityService = SecurityService();
  
  // Para navegar sin contexto si es necesario, aunque lo ideal es pasarlo o usar un NavigatorKey.
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Inicia el cronómetro de inactividad.
  void startListener() {
    _resetTimer();
  }

  /// Detiene el cronómetro.
  void stopListener() {
    _inactivityTimer?.cancel();
  }

  /// Resetea el cronómetro ante cualquier interacción.
  void userInteracted() {
    if (_inactivityTimer != null) {
      _resetTimer();
    }
  }

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(inactivityDuration, _handleTimeout);
  }

  /// Acción a realizar cuando se agota el tiempo.
  Future<void> _handleTimeout() async {
    // Guardar token y tiempo actual antes de cerrar.
    // Simulamos un token para este ejemplo, o lo recuperamos si ya existe.
    String? currentToken = await _securityService.getToken();
    if (currentToken == null) {
      currentToken = "token_de_sesion_expirada_por_inactividad";
      await _securityService.saveToken(currentToken);
    }
    
    await _securityService.saveSessionTime(DateTime.now());

    // Redirigir al login.
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
    
    // Opcional: Mostrar un snackbar o diálogo informando del cierre por inactividad.
    debugPrint("Sesión cerrada por inactividad.");
  }
}
