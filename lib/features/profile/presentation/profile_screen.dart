import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/storage/app_state_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final accessibility = ref.watch(accessibilityProvider);
    final scale = accessibility.textScale.scaleFactor;
    final completedCount = user.completedLessons.length;

    final achievements = [
      {
        'id': 'first_step',
        'title': 'Primer Paso',
        'desc': 'Completaste tu primera lección de programación.',
        'unlocked': completedCount >= 1,
        'icon': Icons.star_rounded,
      },
      {
        'id': 'streak_3',
        'title': 'Racha de Fuego',
        'desc': 'Mantén el hábito diario de estudiar.',
        'unlocked': user.streak >= 1,
        'icon': Icons.local_fire_department_rounded,
      },
      {
        'id': 'variable_master',
        'title': 'Caja de Datos',
        'desc': 'Aprendiste qué es y cómo usar una variable.',
        'unlocked': user.completedLessons.contains('variables_01'),
        'icon': Icons.inbox_rounded,
      },
      {
        'id': 'decision_maker',
        'title': 'Mente Decisiva',
        'desc': 'Superaste la lección de condicionales con "Si".',
        'unlocked': user.completedLessons.contains('conditionals_01'),
        'icon': Icons.alt_route_rounded,
      },
      {
        'id': 'loop_hero',
        'title': 'Sin Cansancio',
        'desc': 'Entendiste cómo repetir instrucciones con bucles.',
        'unlocked': user.completedLessons.contains('loops_01'),
        'icon': Icons.loop_rounded,
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveLayout.horizontalPadding(context)),
      child: ResponsiveContainer(
        maxWidth: 1000,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: AppColors.primaryNeon.withValues(
                        alpha: 0.25,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 44,
                        color: AppColors.secondaryCyan,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.username ?? 'Estudiante',
                                style: AppTypography.headingLarge(scale),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: AppColors.textMuted,
                                ),
                                tooltip: 'Editar nombre',
                                onPressed: () => _showEditNameDialog(
                                  context,
                                  ref,
                                  user.username ?? '',
                                  scale,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Nivel ${user.level} • Aprendiz de Lógica',
                            style: AppTypography.caption(scale).copyWith(
                              color: AppColors.secondaryCyan,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              _statChip(
                                Icons.bolt,
                                '${user.xp} XP',
                                AppColors.primaryNeonLight,
                                scale,
                              ),
                              _statChip(
                                Icons.local_fire_department,
                                '${user.streak} días racha',
                                AppColors.streakFire,
                                scale,
                              ),
                              _statChip(
                                Icons.favorite,
                                '${user.lives}/${user.maxLives} vidas',
                                AppColors.heartYellow,
                                scale,
                              ),
                              _statChip(
                                Icons.check_circle,
                                '$completedCount lecciones',
                                AppColors.successGreen,
                                scale,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            Text(
              'Ajustes de Accesibilidad para Adultos',
              style: AppTypography.headingMedium(scale),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tamaño de Letra de la Interfaz:',
                      style: AppTypography.headingSmall(scale),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ajusta el texto para leer cómodamente sin forzar la vista.',
                      style: AppTypography.caption(scale),
                    ),
                    const SizedBox(height: 14),
                    SegmentedButton<TextScaleLevel>(
                      segments: const [
                        ButtonSegment(
                          value: TextScaleLevel.normal,
                          label: Text('Normal (A)'),
                        ),
                        ButtonSegment(
                          value: TextScaleLevel.large,
                          label: Text('Grande (A+)'),
                        ),
                        ButtonSegment(
                          value: TextScaleLevel.extraLarge,
                          label: Text('Extra (A++)'),
                        ),
                      ],
                      selected: {accessibility.textScale},
                      onSelectionChanged: (set) {
                        ref
                            .read(accessibilityProvider.notifier)
                            .setTextScale(set.first);
                      },
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.surfaceBorder),
                    const SizedBox(height: 16),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Modo Alto Contraste',
                        style: TextStyle(
                          fontSize: 16 * scale,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Aumenta el grosor de los bordes y el brillo de los elementos para mejorar la distinción visual.',
                        style: AppTypography.caption(scale),
                      ),
                      value: accessibility.highContrast,
                      activeThumbColor: AppColors.secondaryCyan,
                      onChanged: (_) => ref
                          .read(accessibilityProvider.notifier)
                          .toggleHighContrast(),
                    ),
                    const SizedBox(height: 12),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Efectos de Audio y Sonido',
                        style: TextStyle(
                          fontSize: 16 * scale,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Reproducir alertas suaves de celebración o aliento.',
                        style: AppTypography.caption(scale),
                      ),
                      value: accessibility.soundEnabled,
                      activeThumbColor: AppColors.secondaryCyan,
                      onChanged: (_) => ref
                          .read(accessibilityProvider.notifier)
                          .toggleSound(),
                    ),
                    const SizedBox(height: 12),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Acabado Cristal Cósmico (Glassmorphism)',
                        style: TextStyle(
                          fontSize: 16 * scale,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        accessibility.glassEffectEnabled
                            ? 'Activo: Efecto espejo y desenfoque óptico de cristal cósmico.'
                            : 'Modo Obsidiana Mate: Fondos sólidos, máxima nitidez y cero reflejos.',
                        style: AppTypography.caption(scale),
                      ),
                      value: accessibility.glassEffectEnabled,
                      activeThumbColor: AppColors.secondaryCyan,
                      onChanged: (_) => ref
                          .read(accessibilityProvider.notifier)
                          .toggleGlassEffect(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            Text(
              'Logros y Medallas Desbloqueadas',
              style: AppTypography.headingMedium(scale),
            ),
            const SizedBox(height: 12),

            LayoutBuilder(
              builder: (context, constraints) {
                final isSingle = constraints.maxWidth < 650;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: achievements.map((ach) {
                    final unlocked = ach['unlocked'] as bool;
                    return SizedBox(
                      width: isSingle
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 12) / 2,
                      child: Card(
                        color: unlocked
                            ? const Color(0xFF19142E)
                            : const Color(0xFF100D1C),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: unlocked
                                      ? AppColors.primaryNeon.withValues(
                                          alpha: 0.2,
                                        )
                                      : Colors.white.withValues(alpha: 0.05),
                                  border: Border.all(
                                    color: unlocked
                                        ? AppColors.secondaryCyan
                                        : Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Icon(
                                  ach['icon'] as IconData,
                                  color: unlocked
                                      ? AppColors.secondaryCyan
                                      : AppColors.textMuted,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ach['title'] as String,
                                      style: TextStyle(
                                        color: unlocked
                                            ? AppColors.textPrimary
                                            : AppColors.textMuted,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15 * scale,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      ach['desc'] as String,
                                      style: AppTypography.caption(scale),
                                    ),
                                  ],
                                ),
                              ),
                              if (unlocked)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.successGreen,
                                  size: 20,
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

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String text, Color color, double scale) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13 * scale,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String current,
    double scale,
  ) {
    final c = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text(
          'Modificar tu nombre',
          style: AppTypography.headingSmall(scale),
        ),
        content: TextField(
          controller: c,
          decoration: const InputDecoration(hintText: 'Nuevo nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (c.text.trim().isNotEmpty) {
                ref
                    .read(userProfileProvider.notifier)
                    .setUsername(c.text.trim());
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
