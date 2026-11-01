import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/storage/app_state_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../lesson/data/sample_lessons.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final accessibility = ref.watch(accessibilityProvider);
    final scale = accessibility.textScale.scaleFactor;
    final modules = SampleLessons.getModules(user.completedLessons);
    final totalLessons = SampleLessons.allLessons.length;
    final completedCount = user.completedLessons.length;
    final progress = totalLessons > 0
        ? (completedCount / totalLessons).clamp(0.0, 1.0)
        : 0.0;
    final percentInt = (progress * 100).toInt();

    String mascotAsset = 'assets/mascot/goat_idle.png';
    final skin = user.mascotSkin;
    if (skin == 'teacher') {
      mascotAsset = 'assets/mascot/goat_teacher.png';
    } else if (skin == 'rocker') {
      mascotAsset = 'assets/mascot/goat_rocker.png';
    } else if (skin == 'happy') {
      mascotAsset = 'assets/mascot/goat_happy.png';
    } else if (skin == 'baby') {
      mascotAsset = 'assets/mascot/goat_baby.png';
    } else if (skin == 'sad') {
      mascotAsset = 'assets/mascot/goat_sad.png';
    } else if (skin == 'shy') {
      mascotAsset = 'assets/mascot/goat_shy.png';
    } else if (skin == 'grumpy') {
      mascotAsset = 'assets/mascot/goat_grumpy.png';
    } else if (skin == 'shocked') {
      mascotAsset = 'assets/mascot/goat_shocked.png';
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveLayout.horizontalPadding(context)),
      child: ResponsiveContainer(
        maxWidth: 1100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryNeon.withValues(alpha: 0.15),
                      const Color(0xFF141026),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Row(
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
                              color: AppColors.secondaryCyan.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'PANEL 1 • CURSO ACTIVO',
                              style: AppTypography.caption(scale).copyWith(
                                color: AppColors.secondaryCyan,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '¡Bienvenido, ${user.username ?? "Estudiante"}!',
                            style: AppTypography.headingLarge(scale)
                                .copyWith(color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tu ritmo es el correcto. Cada lección completada fortalece tu lógica y mantiene tu racha encendida.',
                            style: AppTypography.body(scale),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lógica de Programación',
                                style: AppTypography.headingSmall(scale),
                              ),
                              Text(
                                '$percentInt% completado ($completedCount/$totalLessons)',
                                style: AppTypography.caption(scale).copyWith(
                                  color: AppColors.secondaryCyan,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor: const Color(0xFF262040),
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.secondaryCyan,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.play_arrow_rounded),
                                label: const Text('Continuar Lección'),
                                onPressed: () {
                                  final nextLesson = SampleLessons.allLessons
                                      .firstWhere(
                                        (l) =>
                                            !user.completedLessons.contains(l.id),
                                        orElse: () =>
                                            SampleLessons.allLessons.first,
                                      );
                                  context.go('/lesson/${nextLesson.id}');
                                },
                              ),
                              if (user.lives < user.maxLives)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.heartYellow
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.heartYellow
                                          .withValues(alpha: 0.35),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        size: 14,
                                        color: AppColors.heartYellow,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${user.lives}/${user.maxLives} • Recarga en ${user.formattedTimeUntilNextLife}',
                                        style: TextStyle(
                                          color: AppColors.heartYellow,
                                          fontSize: 12 * scale,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!ResponsiveLayout.isCompact(context)) ...[
                      const SizedBox(width: 24),
                      Image.asset(
                        mascotAsset,
                        width: 160,
                        height: 160,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.pets,
                              color: AppColors.primaryNeon,
                              size: 80,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ruta de Aprendizaje',
                  style: AppTypography.headingMedium(scale),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.map_rounded, size: 18),
                  label: const Text('Ver Mapa Completo'),
                  onPressed: () => context.go('/roadmap'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                final isSingleColumn = constraints.maxWidth < 700;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: modules.map((mod) {
                    final completedInMod = mod.lessons
                        .where((l) => user.completedLessons.contains(l.id))
                        .length;
                    final modProgress = mod.lessons.isNotEmpty
                        ? (completedInMod / mod.lessons.length)
                        : 0.0;
                    final modPercent = (modProgress * 100).toInt();

                    return SizedBox(
                      width: isSingleColumn
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: modProgress == 1.0
                                        ? AppColors.successGreen.withValues(
                                            alpha: 0.2,
                                          )
                                        : AppColors.primaryNeon.withValues(
                                            alpha: 0.2,
                                          ),
                                    child: Icon(
                                      modProgress == 1.0
                                          ? Icons.check
                                          : Icons.code,
                                      color: modProgress == 1.0
                                          ? AppColors.successGreen
                                          : AppColors.secondaryCyan,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mod.title,
                                          style: AppTypography.headingSmall(
                                            scale,
                                          ),
                                        ),
                                        Text(
                                          '$completedInMod de ${mod.lessons.length} lecciones',
                                          style: AppTypography.caption(scale),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '$modPercent%',
                                    style: TextStyle(
                                      color: AppColors.secondaryCyan,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16 * scale,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                mod.description,
                                style: AppTypography.bodyMuted(scale),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    final firstIncomplete = mod.lessons
                                        .firstWhere(
                                          (l) => !user.completedLessons
                                              .contains(l.id),
                                          orElse: () => mod.lessons.first,
                                        );
                                    context.go('/lesson/${firstIncomplete.id}');
                                  },
                                  child: Text(
                                    modProgress == 1.0
                                        ? 'Repasar módulo'
                                        : 'Comenzar módulo',
                                    style: TextStyle(fontSize: 14 * scale),
                                  ),
                                ),
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

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.secondaryCyan.withValues(
                          alpha: 0.2,
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.secondaryCyan,
                        ),
                      ),
                      title: Text(
                        'Ayuda y Analogías',
                        style: AppTypography.headingSmall(scale),
                      ),
                      subtitle: Text(
                        'Consulta explicaciones sencillas sin términos confusos.',
                        style: AppTypography.caption(scale),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.textMuted,
                      ),
                      onTap: () => _showFaqDialog(context, scale),
                    ),
                  ),
                ),
                if (!ResponsiveLayout.isCompact(context)) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryNeon.withValues(
                            alpha: 0.2,
                          ),
                          child: const Icon(
                            Icons.pets,
                            color: AppColors.primaryNeonLight,
                          ),
                        ),
                        title: Text(
                          'Personaliza tu Cabra',
                          style: AppTypography.headingSmall(scale),
                        ),
                        subtitle: Text(
                          'Cambia el atuendo y estilo de tu compañera de estudio.',
                          style: AppTypography.caption(scale),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: AppColors.textMuted,
                        ),
                        onTap: () => context.go('/mascot'),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFaqDialog(BuildContext context, double scale) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Row(
          children: [
            const Icon(Icons.lightbulb, color: AppColors.secondaryCyan),
            const SizedBox(width: 8),
            Text(
              'Guía Rápida para Adultos',
              style: AppTypography.headingSmall(scale),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _faqItem(
                '¿Qué es una Variable?',
                'Es como una caja con una etiqueta donde guardas un número, texto o dato para recordarlo más adelante.',
                scale,
              ),
              const Divider(color: AppColors.surfaceBorder),
              _faqItem(
                '¿Por qué el orden importa?',
                'La computadora sigue la lista de pasos exactamente como una receta. Si mezclas antes de batir, el resultado cambia.',
                scale,
              ),
              const Divider(color: AppColors.surfaceBorder),
              _faqItem(
                '¿Qué pasa si me equivoco?',
                '¡Absolutamente nada malo! No hay límites de tiempo ni vidas que se acaben. Puedes reintentar cuantas veces necesites.',
                scale,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _faqItem(String title, String desc, double scale) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.secondaryCyan,
              fontWeight: FontWeight.w700,
              fontSize: 15 * scale,
            ),
          ),
          const SizedBox(height: 4),
          Text(desc, style: AppTypography.body(scale)),
        ],
      ),
    );
  }
}
