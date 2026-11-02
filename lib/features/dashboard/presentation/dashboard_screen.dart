import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/storage/app_state_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/cosmic_card.dart';
import '../../../core/widgets/lives_badge.dart';
import '../../../core/widgets/mascot_speech_bubble.dart';
import '../../../core/widgets/mascot_streak_aura.dart';
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

    final mascotAsset = user.currentMascotAsset;

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
                child: Builder(
                  builder: (context) {
                    final isCompact = ResponsiveLayout.isCompact(context);

                    final courseColumn = Column(
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
                            Flexible(
                              child: Text(
                                'Lógica de Programación',
                                style: AppTypography.headingSmall(scale),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
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
                              InkWell(
                                onTap: () => showLivesDialog(context, ref),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        (user.canRecoverLife
                                                ? AppColors.successGreen
                                                : AppColors.heartYellow)
                                            .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                          (user.canRecoverLife
                                                  ? AppColors.successGreen
                                                  : AppColors.heartYellow)
                                              .withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        user.canRecoverLife
                                            ? Icons.favorite
                                            : Icons.timer_outlined,
                                        size: 14,
                                        color: user.canRecoverLife
                                            ? AppColors.successGreen
                                            : AppColors.heartYellow,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        user.canRecoverLife
                                            ? '${user.lives}/${user.maxLives} • ¡Recuperar vida!'
                                            : (isCompact
                                                  ? '${user.lives}/${user.maxLives} • ${user.formattedTimeUntilNextLife}'
                                                  : '${user.lives}/${user.maxLives} • Espera ${user.formattedTimeUntilNextLife}'),
                                        style: TextStyle(
                                          color: user.canRecoverLife
                                              ? AppColors.successGreen
                                              : AppColors.heartYellow,
                                          fontSize: 12 * scale,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (isCompact) ...[
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF130F24),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: user.goatMood.color.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                MascotStreakAura(
                                  streak: user.streak,
                                  size: 56,
                                  showBadge: false,
                                  scale: scale,
                                  child: Image.asset(
                                    mascotAsset,
                                    key: ValueKey('compact_hero_$mascotAsset'),
                                    width: 58,
                                    height: 58,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.pets,
                                              color: AppColors.primaryNeon,
                                              size: 40,
                                            ),
                                  ).animateBreathing(),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            user.goatMood.icon,
                                            size: 14,
                                            color: user.goatMood.color,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              'Estado: ${user.goatMood.displayName}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: user.goatMood.color,
                                                fontSize: 12 * scale,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user.mascotSpeechMessage,
                                        style: AppTypography.caption(scale)
                                            .copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );

                    if (isCompact) {
                      return courseColumn;
                    }

                    return Row(
                      children: [
                        Expanded(child: courseColumn),
                        const SizedBox(width: 24),
                        SizedBox(
                          width: 230,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MascotSpeechBubble(
                                text: user.mascotSpeechMessage,
                                title: user.goatMood.showsSadGesture
                                    ? 'GoatCode • Ánimo: ${user.goatMood.shortLabel}'
                                    : 'GoatCode',
                                scale: scale,
                              ),
                              const SizedBox(height: 10),
                              MascotStreakAura(
                                streak: user.streak,
                                size: 110,
                                scale: scale,
                                child: Image.asset(
                                  mascotAsset,
                                  key: ValueKey(mascotAsset),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.pets,
                                        color: AppColors.primaryNeon,
                                        size: 70,
                                      ),
                                ).animateBreathing(),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: user.goatMood.color.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: user.goatMood.color.withValues(
                                      alpha: 0.45,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      user.goatMood.icon,
                                      size: 13,
                                      color: user.goatMood.color,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Ánimo: ${user.goatMood.shortLabel}',
                                      style: TextStyle(
                                        color: user.goatMood.color,
                                        fontSize: 11 * scale,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ).animateEntrance(index: 0),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Ruta de Aprendizaje',
                    style: AppTypography.headingMedium(scale),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
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
                  children: List.generate(modules.length, (idx) {
                    final mod = modules[idx];
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
                      child: CosmicCard(
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
                                        (l) => !user.completedLessons.contains(
                                          l.id,
                                        ),
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
                      ).animateEntrance(index: idx + 1),
                    );
                  }),
                );
              },
            ),

            const SizedBox(height: 32),

            if (ResponsiveLayout.isCompact(context)) ...[
              CosmicCard(
                padding: EdgeInsets.zero,
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
              ).animateEntrance(index: modules.length + 1),
              const SizedBox(height: 14),
              CosmicCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: user.goatMood.color.withValues(alpha: 0.2),
                    child: Image.asset(
                      user.currentMascotAsset,
                      key: ValueKey(
                        'dash_card_compact_${user.currentMascotAsset}',
                      ),
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        user.goatMood.showsSadGesture
                            ? Icons.sentiment_dissatisfied
                            : Icons.pets,
                        color: user.goatMood.color,
                      ),
                    ),
                  ),
                  title: Text(
                    user.goatMood.showsSadGesture
                        ? 'Estado: Cabra Triste'
                        : 'Personaliza tu Cabra',
                    style: AppTypography.headingSmall(scale),
                  ),
                  subtitle: Text(
                    user.goatMood.showsSadGesture
                        ? 'Cabra triste por pérdida de vidas (${user.lives}/${user.maxLives} ❤️). Espera 15 min para recuperar vida.'
                        : 'Cambia el atuendo y estilo de tu compañera de estudio.',
                    style: AppTypography.caption(scale),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                  ),
                  onTap: () => context.go('/mascot'),
                ),
              ).animateEntrance(index: modules.length + 2),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: CosmicCard(
                      padding: EdgeInsets.zero,
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
                    ).animateEntrance(index: modules.length + 1),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CosmicCard(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: user.goatMood.color.withValues(
                            alpha: 0.2,
                          ),
                          child: Image.asset(
                            user.currentMascotAsset,
                            key: ValueKey(
                              'dash_card_${user.currentMascotAsset}',
                            ),
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              user.goatMood.showsSadGesture
                                  ? Icons.sentiment_dissatisfied
                                  : Icons.pets,
                              color: user.goatMood.color,
                            ),
                          ),
                        ),
                        title: Text(
                          user.goatMood.showsSadGesture
                              ? 'Estado: Cabra Triste'
                              : 'Personaliza tu Cabra',
                          style: AppTypography.headingSmall(scale),
                        ),
                        subtitle: Text(
                          user.goatMood.showsSadGesture
                              ? 'Cabra triste por pérdida de vidas (${user.lives}/${user.maxLives} ❤️). Espera 15 min para recuperar vida.'
                              : 'Cambia el atuendo y estilo de tu compañera de estudio.',
                          style: AppTypography.caption(scale),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: AppColors.textMuted,
                        ),
                        onTap: () => context.go('/mascot'),
                      ),
                    ).animateEntrance(index: modules.length + 2),
                  ),
                ],
              ),
            ],
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
