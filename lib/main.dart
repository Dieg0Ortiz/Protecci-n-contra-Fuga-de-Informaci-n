import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/security_block_screen.dart';
import 'services/session_manager.dart';
import 'services/security_check_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verificar integridad del dispositivo antes de arrancar
  final securityService = SecurityCheckService();
  bool isCompromised = await securityService.isDeviceCompromised();

  // Configurar la barra de estado transparente
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.primaryDark,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(FarmaFindApp(isBlocked: isCompromised));
}

/// Aplicación principal de FarmaFind.
class FarmaFindApp extends StatelessWidget {
  final bool isBlocked;

  const FarmaFindApp({super.key, this.isBlocked = false});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => SessionManager().userInteracted(),
      behavior: HitTestBehavior.translucent,
      child: MaterialApp(
        title: 'FarmaFind',
        navigatorKey: SessionManager.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: isBlocked 
          ? const SecurityBlockScreen(reason: 'Esta aplicación no puede ejecutarse en dispositivos con Fake GPS o Root detectado.')
          : const LoginScreen(),
      ),
    );
  }
}
