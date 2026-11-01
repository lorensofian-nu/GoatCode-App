import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/storage/app_state_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class MascotScreen extends ConsumerStatefulWidget {
  const MascotScreen({super.key});

  @override
  ConsumerState<MascotScreen> createState() => _MascotScreenState();
}

class _MascotScreenState extends ConsumerState<MascotScreen> {
  late String _selectedSkin;

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
            const SizedBox(height: 28),

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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondaryCyan.withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 28,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        activeSkinData['asset']!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.pets,
                              size: 100,
                              color: AppColors.primaryNeon,
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      activeSkinData['name']!,
                      style: AppTypography.headingMedium(scale)
                          .copyWith(color: AppColors.secondaryCyan),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activeSkinData['desc']!,
                      style: AppTypography.bodyMuted(scale),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            Text('Elige un atuendo:', style: AppTypography.headingSmall(scale)),
            const SizedBox(height: 14),

            LayoutBuilder(
              builder: (context, constraints) {
                final isSingle = constraints.maxWidth < 650;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _skins.map((skin) {
                    final isSelected = _selectedSkin == skin['id'];
                    return SizedBox(
                      width: isSingle
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 12) / 2,
                      child: InkWell(
                        onTap: () =>
                            setState(() => _selectedSkin = skin['id']!),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
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
                    );
                  }).toList(),
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
