import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/session_manager.dart';
import 'login_screen.dart';

/// Pantalla principal (dashboard) de FarmaFind tras login exitoso.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.buttonGradient,
            ),
            child: const Center(
              child: Icon(Icons.local_pharmacy_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppTheme.primaryGreen, AppTheme.accentTeal],
                  ).createShader(bounds),
                  child: const Text('FarmaFind',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      )),
                ),
                Text('Panel de Administración',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary.withValues(alpha: 0.7),
                    )),
              ],
            ),
          ),
          // Badge de seguridad
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusXL),
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              border: Border.all(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_rounded,
                    size: 14,
                    color: AppTheme.primaryGreen.withValues(alpha: 0.8)),
                const SizedBox(width: 4),
                Text('Seguro',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryGreen.withValues(alpha: 0.8),
                    )),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Botón cerrar sesión
          IconButton(
            onPressed: () {
              SessionManager().stopListener();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const LoginScreen()),
              );
            },
            icon: Icon(Icons.logout_rounded,
                color: AppTheme.textSecondary.withValues(alpha: 0.6)),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bienvenida
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              gradient: AppTheme.buttonGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.waving_hand_rounded,
                        color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text('¡Bienvenido, Admin!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                    'Acceso verificado. Esta sesión está protegida contra capturas de pantalla.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats rápidos
          const Text('Resumen del Sistema',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              )),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _statCard(Icons.local_pharmacy_rounded,
                      '1,248', 'Farmacias', AppTheme.primaryGreen)),
              const SizedBox(width: 12),
              Expanded(
                  child: _statCard(Icons.medication_rounded, '45,320',
                      'Medicamentos', AppTheme.accentTeal)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _statCard(Icons.people_rounded, '8,912',
                      'Usuarios', AppTheme.accentBlue)),
              const SizedBox(width: 12),
              Expanded(
                  child: _statCard(Icons.search_rounded, '23,456',
                      'Búsquedas hoy', AppTheme.warning)),
            ],
          ),
          const SizedBox(height: 24),

          // Seguridad info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              gradient: AppTheme.cardGradient,
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.security_rounded,
                        color: AppTheme.primaryGreen.withValues(alpha: 0.8),
                        size: 22),
                    const SizedBox(width: 10),
                    const Text('Estado de Seguridad',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        )),
                  ],
                ),
                const SizedBox(height: 16),
                _securityRow(Icons.screenshot_rounded,
                    'Capturas de pantalla', 'Bloqueadas', true),
                const SizedBox(height: 10),
                _securityRow(Icons.screen_share_rounded,
                    'Grabación de pantalla', 'Bloqueada', true),
                const SizedBox(height: 10),
                _securityRow(Icons.lock_rounded,
                    'Cifrado TLS', 'Activo', true),
                const SizedBox(height: 10),
                _securityRow(Icons.admin_panel_settings_rounded,
                    'RBAC', 'Configurado', true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        gradient: AppTheme.cardGradient,
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              )),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
              )),
        ],
      ),
    );
  }

  Widget _securityRow(
      IconData icon, String title, String status, bool active) {
    return Row(
      children: [
        Icon(icon,
            size: 18,
            color: active
                ? AppTheme.success.withValues(alpha: 0.8)
                : AppTheme.error.withValues(alpha: 0.8)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(title,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              )),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            color: (active ? AppTheme.success : AppTheme.error)
                .withValues(alpha: 0.12),
          ),
          child: Text(status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: active ? AppTheme.success : AppTheme.error,
              )),
        ),
      ],
    );
  }
}
