import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar la barra de estado transparente para una UI inmersiva.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.primaryDark,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const FarmaFindApp());
}

/// Aplicación principal de FarmaFind.
/// Incluye protección contra capturas de pantalla a nivel nativo
/// (Android: FLAG_SECURE, iOS: secure text field container).
class FarmaFindApp extends StatelessWidget {
  const FarmaFindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmaFind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
