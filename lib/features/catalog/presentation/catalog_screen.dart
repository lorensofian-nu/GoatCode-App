import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/storage/app_state_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/cosmic_card.dart';
import '../../lesson/data/sample_lessons.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final accessibility = ref.watch(accessibilityProvider);
    final scale = accessibility.textScale.scaleFactor;
    final completedCount = user.completedLessons.length;
    final totalLessons = SampleLessons.allLessons.length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveLayout.horizontalPadding(context)),
      child: ResponsiveContainer(
        maxWidth: 1100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNeon.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PANEL 2',
                    style: AppTypography.caption(scale).copyWith(
                      color: AppColors.primaryNeonLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Catálogo de Cursos',
                  style: AppTypography.headingLarge(scale),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Explora las rutas formativas disponibles. Diseñadas para dominar los fundamentos sin prisa.',
              style: AppTypography.body(scale),
            ),
            const SizedBox(height: 24),

            // Active Featured Course: Lógica de Programación (Wireframe 02)
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.secondaryCyan.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryNeon.withValues(alpha: 0.12),
                      const Color(0xFF161228),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.successGreen.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'CURSO ACTIVO Y DISPONIBLE',
                                  style: AppTypography.caption(scale).copyWith(
                                    color: AppColors.successGreen,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Lógica de Programación',
                                style: AppTypography.display(scale)
                                    .copyWith(color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'El punto de partida ideal. Aprende el pensamiento estructurado, cómo almacenar datos en variables, tomar decisiones condicionales y automatizar con bucles.',
                                style: AppTypography.body(scale),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _tagChip('5 Módulos', scale),
                                  _tagChip('Sin límite de tiempo', scale),
                                  _tagChip('100% Offline', scale),
                                  _tagChip('Analogías claras', scale),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!ResponsiveLayout.isCompact(context)) ...[
                          const SizedBox(width: 24),
                          Image.asset(
                            'assets/mascot/goat_teacher.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.code,
                                  size: 80,
                                  color: AppColors.secondaryCyan,
                                ),
                          ).animateBreathing(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.surfaceBorder),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progreso: $completedCount de $totalLessons lecciones',
                          style: AppTypography.caption(scale).copyWith(
                            color: AppColors.secondaryCyan,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('Entrar al curso'),
                          onPressed: () {
                            final next = SampleLessons.allLessons.firstWhere(
                              (l) => !user.completedLessons.contains(l.id),
                              orElse: () => SampleLessons.allLessons.first,
                            );
                            context.go('/lesson/${next.id}');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animateEntrance(index: 0),
            const SizedBox(height: 32),

            Text(
              'Próximas Rutas de Aprendizaje',
              style: AppTypography.headingMedium(scale),
            ),
            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                final isSingle = constraints.maxWidth < 700;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _futureCourseCard(
                      title: 'Estructuras de Datos Cotidianas',
                      description: 'Listas, pilas y diccionarios explicados como agendas telefónicas y estantes organizados.',
                      badge: 'PRÓXIMAMENTE',
                      width: isSingle
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                      scale: scale,
                    ),
                    _futureCourseCard(
                      title: 'Desarrollo con Dart y Flutter',
                      description: 'Da el salto de la lógica pura a la creación de tus primeras aplicaciones visuales e interactivas.',
                      badge: 'PRÓXIMAMENTE',
                      width: isSingle
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                      scale: scale,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF120E22),
                  border: Border.all(
                    color: AppColors.primaryNeon.withValues(alpha: 0.3),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/mascot/goat_rocker.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.groups,
                        color: AppColors.primaryNeon,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                color: AppColors.streakFire,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Próximamente: Modo Online Colaborativo',
                                style: AppTypography.headingSmall(scale)
                                    .copyWith(color: AppColors.secondaryCyan),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'En futuras versiones podrás resolver retos en equipo con otros adultos y comparar soluciones sin presiones de tiempo.',
                            style: AppTypography.caption(scale),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagChip(String label, double scale) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12 * scale,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _futureCourseCard({
    required String title,
    required String description,
    required String badge,
    required double width,
    required double scale,
    int index = 1,
  }) {
    return SizedBox(
      width: width,
      child: CosmicCard(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warningAmber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: AppColors.warningAmber,
                  fontSize: 11 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTypography.headingSmall(scale)),
            const SizedBox(height: 8),
            Text(description, style: AppTypography.bodyMuted(scale)),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: null,
              child: Text('Bloqueado', style: TextStyle(fontSize: 13 * scale)),
            ),
          ],
        ),
      ).animateEntrance(index: index),
    );
  }
}
