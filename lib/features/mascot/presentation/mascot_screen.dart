import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/storage/app_state_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/mascot_streak_aura.dart';

class MascotScreen extends ConsumerStatefulWidget {
  const MascotScreen({super.key});

  @override
  ConsumerState<MascotScreen> createState() => _MascotScreenState();
}

class _MascotScreenState extends ConsumerState<MascotScreen> {
  late String _selectedSkin;
  bool _previewCurrentMood = false;

  final List<Map<String, String>> _skins = [
    {
      'id': 'idle',
      'name': 'Cabra Natural',
      'desc': 'Aspecto original, atenta y lista para aprender.',
      'asset': 'assets/mascot/goat_idle.png',
    },
    {
      'id': 'teacher',
      'name': 'Cabra Profesora',
      'desc':
          'Con gafas y bufanda roja. Ideal para explicar conceptos complejos.',
      'asset': 'assets/mascot/goat_teacher.png',
    },
    {
      'id': 'rocker',
      'name': 'Cabra Rockera',
      'desc': 'Camiseta "The GOATS". Pasión y energía para programar.',
      'asset': 'assets/mascot/goat_rocker.png',
    },
    {
      'id': 'baby',
      'name': 'Cabra Bebé',
      'desc': 'Con gorrito de dormir. Para quienes dan sus primeros pasos.',
      'asset': 'assets/mascot/goat_baby.png',
    },
    {
      'id': 'happy',
      'name': 'Cabra Feliz',
      'desc': 'Sonriente y entusiasmada por cada línea de código resuelta.',
      'asset': 'assets/mascot/goat_happy.png',
    },
    {
      'id': 'shy',
      'name': 'Cabra Tímida',
      'desc': 'Tranquila y reflexiva. Prefiere pensar antes de ejecutar.',
      'asset': 'assets/mascot/goat_shy.png',
    },
    {
      'id': 'shocked',
      'name': 'Cabra Asombrada',
      'desc': 'Sorprendida al descubrir el poder de la programación.',
      'asset': 'assets/mascot/goat_shocked.png',
    },
    {
      'id': 'grumpy',
      'name': 'Cabra Gruñona',
      'desc': 'Concentrada cazando errores y depurando bugs.',
      'asset': 'assets/mascot/goat_grumpy.png',
    },
    {
      'id': 'sad',
      'name': 'Cabra Comprensiva',
      'desc': 'Empática cuando un test no pasa, lista para reintentar.',
      'asset': 'assets/mascot/goat_sad.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedSkin = ref.read(userProfileProvider).mascotSkin;
  }

  void _saveLook() {
    ref.read(userProfileProvider.notifier).updateMascotSkin(_selectedSkin);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Look de tu Cabra guardado exitosamente!'),
        backgroundColor: AppColors.successGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final accessibility = ref.watch(accessibilityProvider);
    final scale = accessibility.textScale.scaleFactor;
    final activeSkinData = _skins.firstWhere(
      (s) => s['id'] == _selectedSkin,
      orElse: () => _skins.first,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveLayout.horizontalPadding(context)),
      child: ResponsiveContainer(
        maxWidth: 960,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personalizar Cabra',
              style: AppTypography.headingLarge(scale),
            ),
            const SizedBox(height: 6),
            Text(
              'Elige cómo quieres que tu compañera cabra se vista durante tus lecciones y en el dashboard.',
              style: AppTypography.body(scale),
            ),
            const SizedBox(height: 16),

            // Banner explicativo de la Regla de Estado de Ánimo según vidas disponibles
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: user.goatMood.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: user.goatMood.color.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    user.goatMood.icon,
                    color: user.goatMood.color,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Estado de Ánimo: ${user.goatMood.displayName}',
                              style: AppTypography.headingSmall(scale).copyWith(
                                color: user.goatMood.color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.heartYellow.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${user.lives}/${user.maxLives} ❤️',
                                style: TextStyle(
                                  color: AppColors.heartYellow,
                                  fontSize: 11 * scale,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.goatMood.showsSadGesture
                              ? 'Al haber bajado a ${user.lives} vidas (cantidad considerable), el gesto de tu cabra cambia automáticamente a triste para acompañarte. Puedes cambiar su atuendo, el cual volverá a lucir animado cuando recargues vidas.'
                              : 'Regla activa: El estado de ánimo de tu cabra refleja tus vidas en tiempo real. Si tus vidas bajan a 2 o menos, su gesto cambiará a triste.',
                          style: AppTypography.caption(scale)
                              .copyWith(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Main Stage: Podium & Mascot (Wireframe 04 center)
            Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 36,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryNeon.withValues(alpha: 0.25),
                      const Color(0xFF130F24),
                    ],
                    radius: 0.9,
                  ),
                ),
                child: Column(
                  children: [
                    if (user.goatMood.showsSadGesture) ...[
                      Wrap(
                        spacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          ChoiceChip(
                            label: const Text('Atuendo seleccionado'),
                            selected: !_previewCurrentMood,
                            onSelected: (val) {
                              if (val) {
                                setState(() => _previewCurrentMood = false);
                              }
                            },
                          ),
                          ChoiceChip(
                            avatar: Icon(
                              Icons.sentiment_dissatisfied,
                              size: 16,
                              color: user.goatMood.color,
                            ),
                            label: Text(
                              'Gesto triste actual (${user.lives} vidas)',
                            ),
                            selected: _previewCurrentMood,
                            onSelected: (val) {
                              if (val) {
                                setState(() => _previewCurrentMood = true);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    MascotStreakAura(
                      streak: user.streak,
                      size: 210,
                      scale: scale,
                      child: Image.asset(
                        (_previewCurrentMood && user.goatMood.showsSadGesture)
                            ? 'assets/mascot/goat_sad.png'
                            : activeSkinData['asset']!,
                        key: ValueKey('${_selectedSkin}_$_previewCurrentMood'),
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.pets,
                              size: 100,
                              color: AppColors.primaryNeon,
                            ),
                      ).animateCelebrate().animateBreathing(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      (_previewCurrentMood && user.goatMood.showsSadGesture)
                          ? 'Gesto Triste (Por vidas bajas)'
                          : activeSkinData['name']!,
                      style: AppTypography.headingMedium(scale)
                          .copyWith(color: AppColors.secondaryCyan),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      (_previewCurrentMood && user.goatMood.showsSadGesture)
                          ? 'Tu cabra siente empatía cuando quedan pocas vidas (${user.lives}/${user.maxLives}).'
                          : activeSkinData['desc']!,
                      style: AppTypography.bodyMuted(scale),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ).animateEntrance(index: 0),
            const SizedBox(height: 28),

            Text('Elige un atuendo:', style: AppTypography.headingSmall(scale)),
            const SizedBox(height: 14),

            LayoutBuilder(
              builder: (context, constraints) {
                final isSingle = constraints.maxWidth < 650;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(_skins.length, (idx) {
                    final skin = _skins[idx];
                    final isSelected = _selectedSkin == skin['id'];
                    return SizedBox(
                      width: isSingle
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 12) / 2,
                      child: InkWell(
                        onTap: () =>
                            setState(() => _selectedSkin = skin['id']!),
                        borderRadius: BorderRadius.circular(14),
                        child: AnimatedContainer(
                          duration: AppMotion.durationMicro,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryNeon.withValues(alpha: 0.18)
                                : const Color(0xFF141026),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.secondaryCyan
                                  : AppColors.surfaceBorder,
                              width: isSelected ? 2.0 : 1.0,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: AppColors.secondaryCyan.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 12,
                                ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                skin['asset']!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.pets),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      skin['name']!,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.secondaryCyan
                                            : AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15 * scale,
                                      ),
                                    ),
                                    Text(
                                      skin['desc']!,
                                      style: AppTypography.caption(scale),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.secondaryCyan,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ).animateEntrance(index: idx + 1);
                  }),
                );
              },
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_rounded),
                label: Text(
                  'Guardar look',
                  style: TextStyle(fontSize: 16 * scale),
                ),
                onPressed: _saveLook,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
