import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  static const String _demoEmail = 'admin@farmafind.mx';
  static const String _demoPassword = 'FarmaFind2024!';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email == _demoEmail && password == _demoPassword) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Credenciales incorrectas. Intenta de nuevo.';
      });
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildSecurityBadge(),
                    const SizedBox(height: 32),
                    _buildLogo(),
                    const SizedBox(height: 12),
                    _buildBranding(),
                    const SizedBox(height: 40),
                    _buildLoginCard(),
                    const SizedBox(height: 24),
                    _buildDemoCredentials(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityBadge() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
            border: Border.all(
              color: AppTheme.primaryGreen
                  .withValues(alpha: 0.3 + (_pulseAnimation.value * 0.2)),
            ),
            color: AppTheme.primaryGreen.withValues(alpha: 0.08),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield_outlined, size: 16,
                  color: AppTheme.primaryGreen
                      .withValues(alpha: 0.7 + (_pulseAnimation.value * 0.3))),
              const SizedBox(width: 8),
              Text('PANTALLA PROTEGIDA',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGreen
                        .withValues(alpha: 0.7 + (_pulseAnimation.value * 0.3)),
                    letterSpacing: 1.5,
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.buttonGradient,
        boxShadow: AppTheme.glowShadow,
      ),
      child: const Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.location_on_rounded, size: 48, color: Colors.white),
            Positioned(
              top: 18,
              child: Icon(Icons.local_pharmacy_rounded,
                  size: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranding() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppTheme.primaryGreen, AppTheme.accentTeal],
          ).createShader(bounds),
          child: const Text('FarmaFind',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              )),
        ),
        const SizedBox(height: 6),
        Text('Localizador Inteligente de Medicamentos',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        gradient: AppTheme.cardGradient,
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Iniciar Sesión',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 4),
            Text('Ingresa tus credenciales de acceso',
                style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary.withValues(alpha: 0.7))),
            const SizedBox(height: 28),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style:
                  const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
              decoration: const InputDecoration(
                hintText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa tu correo electrónico';
                }
                if (!value.contains('@')) return 'Ingresa un correo válido';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style:
                  const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.textHint,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu contraseña';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            if (_errorMessage != null) _buildErrorMsg(),
            const SizedBox(height: 24),
            _buildLoginButton(),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text('¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: AppTheme.accentTeal.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMsg() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        color: AppTheme.error.withValues(alpha: 0.12),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppTheme.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(_errorMessage!,
                style: const TextStyle(
                    color: AppTheme.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleLogin,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          gradient: _isLoading
              ? LinearGradient(colors: [
                  AppTheme.primaryGreen.withValues(alpha: 0.5),
                  AppTheme.accentTeal.withValues(alpha: 0.5),
                ])
              : AppTheme.buttonGradient,
          boxShadow: _isLoading
              ? []
              : [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white)))
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login_rounded,
                        color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text('INICIAR SESIÓN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        )),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDemoCredentials() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
            color: AppTheme.accentTeal.withValues(alpha: 0.2)),
        color: AppTheme.accentTeal.withValues(alpha: 0.05),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16,
                  color: AppTheme.accentTeal.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Text('Credenciales de demostración',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentTeal.withValues(alpha: 0.8),
                    letterSpacing: 0.5,
                  )),
            ],
          ),
          const SizedBox(height: 10),
          _credRow(Icons.email_outlined, 'Email:', _demoEmail),
          const SizedBox(height: 6),
          _credRow(Icons.key_rounded, 'Pass:', _demoPassword),
        ],
      ),
    );
  }

  Widget _credRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: AppTheme.textHint),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textHint,
                fontWeight: FontWeight.w500)),
        const SizedBox(width: 4),
        SelectableText(value,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            )),
      ],
    );
  }
}
