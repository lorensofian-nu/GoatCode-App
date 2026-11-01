import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/storage/app_state_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_typography.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(
        () => _error = 'Por favor escribe tu nombre o apodo para saludarte.',
      );
      return;
    }
    ref.read(userProfileProvider.notifier).setUsername(name);
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final accessibility = ref.watch(accessibilityProvider);
    final scale = accessibility.textScale.scaleFactor;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ResponsiveContainer(
              maxWidth: 540,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/mascot/goat_teacher.png',
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.pets,
                              color: AppColors.primaryNeon,
                              size: 80,
                            ),
                      ).animateBreathing(),
                      const SizedBox(height: 24),
                      Text(
                        '¡Bienvenido a GoatCode!',
                        style: AppTypography.display(scale)
                            .copyWith(color: AppColors.secondaryCyan),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aprende lógica de programación a tu propio ritmo. Explicaciones sencillas, práctica guiada y sin presiones de tiempo.',
                        style: AppTypography.body(scale),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '¿Cómo te gustaría que te llamemos?',
                          style: AppTypography.headingSmall(scale),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        style: TextStyle(
                          fontSize: 16 * scale,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ej. María o Carlos',
                          prefixIcon: const Icon(
                            Icons.person,
                            color: AppColors.primaryNeon,
                          ),
                          errorText: _error,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(
                            'Comenzar mi aprendizaje',
                            style: TextStyle(fontSize: 16 * scale),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '100% Offline • Sin contraseñas ni recolección de datos',
                        style: AppTypography.caption(scale),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ).animateEntrance(index: 0),
            ),
          ),
        ),
      ),
    );
  }
}
