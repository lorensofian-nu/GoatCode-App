import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/storage/app_state_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/lives_badge.dart';
import '../data/sample_lessons.dart';
import '../domain/lesson_models.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const LessonScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  int? _selectedChoiceIndex;
  bool _showFeedback = false;
  bool _isSuccess = false;
  bool _showHint = false;

  @override
  Widget build(BuildContext context) {
    final lesson = SampleLessons.getLessonById(widget.lessonId);
    final user = ref.watch(userProfileProvider);
    final accessibility = ref.watch(accessibilityProvider);
    final scale = accessibility.textScale.scaleFactor;

    if (lesson == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lección no encontrada',
                style: AppTypography.headingMedium(scale),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Volver al Dashboard'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.moduleTitle,
              style: AppTypography.caption(scale)
                  .copyWith(color: AppColors.secondaryCyan),
            ),
            Text(lesson.title, style: AppTypography.headingSmall(scale)),
          ],
        ),
        actions: [
          const LivesBadge(compact: true, showCountdown: false),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Ver pista',
            icon: Icon(
              _showHint ? Icons.lightbulb : Icons.lightbulb_outline,
              color: AppColors.warningAmber,
            ),
            onPressed: () => setState(() => _showHint = !_showHint),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveLayout.horizontalPadding(context),
            vertical: 20,
          ),
          child: ResponsiveContainer(
            maxWidth: 820,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_showHint) ...[
                  Card(
                    color: const Color(0xFF231B0D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(
                        color: AppColors.warningAmber,
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb,
                            color: AppColors.warningAmber,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pista de la Cabra:',
                                  style: AppTypography.caption(scale).copyWith(
                                    color: AppColors.warningAmber,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lesson.hint,
                                  style: AppTypography.body(scale),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Section 1: TEORÍA (Wireframe 03)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryNeon.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'TEORÍA',
                                style: TextStyle(
                                  color: AppColors.primaryNeonLight,
                                  fontSize: 12 * scale,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                lesson.analogyTitle,
                                style: AppTypography.headingSmall(scale),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          lesson.analogyText,
                          style: AppTypography.body(scale),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Section 2: EJEMPLO DE CÓDIGO (Wireframe 03)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryCyan.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'EJEMPLO',
                                style: TextStyle(
                                  color: AppColors.secondaryCyan,
                                  fontSize: 12 * scale,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                            Text(
                              'Código estructurado',
                              style: AppTypography.caption(scale),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.codeBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.surfaceBorder),
                          ),
                          child: SelectableText(
                            lesson.codeSnippet,
                            style: AppTypography.code(scale)
                                .copyWith(color: AppColors.secondaryCyan),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Section 3: PREGUNTA INTERACTIVA (Wireframe 03)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.streakFire.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'PREGUNTA PRÁCTICA',
                            style: TextStyle(
                              color: AppColors.streakFire,
                              fontSize: 12 * scale,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          lesson.question,
                          style: AppTypography.headingSmall(scale),
                        ),
                        const SizedBox(height: 20),

                        // Options list
                        ...List.generate(lesson.choices.length, (idx) {
                          final choice = lesson.choices[idx];
                          final isSelected = _selectedChoiceIndex == idx;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: InkWell(
                              onTap: _showFeedback
                                  ? null
                                  : () => setState(
                                      () => _selectedChoiceIndex = idx,
                                    ),
                              borderRadius: BorderRadius.circular(14),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryNeon.withValues(
                                          alpha: 0.2,
                                        )
                                      : const Color(0xFF130F24),
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
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.secondaryCyan
                                              : AppColors.textMuted,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? AppColors.secondaryCyan
                                            : Colors.transparent,
                                      ),
                                      child: isSelected
                                          ? const Center(
                                              child: Icon(
                                                Icons.check,
                                                size: 14,
                                                color: Colors.black,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        choice.text,
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.textPrimary
                                              : AppColors.textSecondary,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: 15 * scale,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Feedback Banner if evaluated
                if (_showFeedback) ...[
                  _buildFeedbackCard(lesson, scale),
                  const SizedBox(height: 24),
                ],

                // Out of lives warning banner if user has 0 lives
                if (user.lives == 0 && !_showFeedback) ...[
                  Card(
                    color: const Color(0xFF2A1015),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(
                        color: Color(0xFFFF4B4B),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            color: Color(0xFFFF4B4B),
                            size: 28,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¡Sin vidas disponibles!',
                                  style: TextStyle(
                                    color: const Color(0xFFFF4B4B),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14 * scale,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Próxima vida en: ${user.formattedTimeUntilNextLife}. Espera la recarga o recarga tus vidas.',
                                  style: AppTypography.caption(scale),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => showLivesDialog(context, ref),
                            child: const Text('Recargar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action Button
                if (!_showFeedback)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: user.lives == 0
                          ? () => showLivesDialog(context, ref)
                          : (_selectedChoiceIndex == null
                              ? null
                              : () => _evaluate(lesson)),
                      style: user.lives == 0
                          ? ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E1922),
                              foregroundColor: const Color(0xFFFF5964),
                            )
                          : null,
                      child: Text(
                        user.lives == 0
                            ? 'Sin vidas (Toca para recargar)'
                            : 'Comprobar respuesta',
                        style: TextStyle(fontSize: 16 * scale),
                      ),
                    ),
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _evaluate(Lesson lesson) {
    final user = ref.read(userProfileProvider);
    if (user.lives <= 0) {
      showLivesDialog(context, ref);
      return;
    }

    final isCorrect = _selectedChoiceIndex == lesson.correctChoiceIndex;
    setState(() {
      _showFeedback = true;
      _isSuccess = isCorrect;
    });

    if (isCorrect) {
      ref.read(userProfileProvider.notifier).completeLesson(lesson.id);
    } else {
      ref.read(userProfileProvider.notifier).loseLife();
    }
  }

  Widget _buildFeedbackCard(Lesson lesson, double scale) {
    final isSuccess = _isSuccess;
    final user = ref.watch(userProfileProvider);
    final isOutOfLives = !isSuccess && user.lives == 0;

    final mascotImage = isSuccess
        ? 'assets/mascot/goat_happy.png'
        : (isOutOfLives
            ? 'assets/mascot/goat_shocked.png'
            : 'assets/mascot/goat_sad.png');

    return Card(
      color: isSuccess ? const Color(0xFF0F2B1C) : const Color(0xFF2D1418),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSuccess ? AppColors.successGreen : AppColors.errorSoft,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  mascotImage,
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    isSuccess
                        ? Icons.celebration
                        : (isOutOfLives
                            ? Icons.heart_broken
                            : Icons.sentiment_dissatisfied),
                    color: isSuccess
                        ? AppColors.successGreen
                        : AppColors.errorSoft,
                    size: 48,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSuccess
                            ? '¡Respuesta Correcta! (+100 XP)'
                            : (isOutOfLives
                                ? '¡Te has quedado sin vidas!'
                                : 'Casi lo logras... (-1 Vida ❤️)'),
                        style: TextStyle(
                          color: isSuccess
                              ? AppColors.successGreen
                              : AppColors.errorSoft,
                          fontWeight: FontWeight.w700,
                          fontSize: 17 * scale,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isSuccess
                            ? lesson.explanationSuccess
                            : (isOutOfLives
                                ? 'Has agotado tus 5 vidas. Tu cabra se está tomando un descanso. Tus vidas se recargarán automáticamente con el tiempo o puedes recargarlas ahora.'
                                : lesson.explanationFailure),
                        style: AppTypography.body(scale),
                      ),
                      if (!isSuccess && !isOutOfLives) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Color(0xFFFF4B4B),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Te quedan ${user.lives} vidas.',
                              style: TextStyle(
                                color: const Color(0xFFFF7B7B),
                                fontSize: 13 * scale,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isSuccess) ...[
                  if (isOutOfLives) ...[
                    OutlinedButton.icon(
                      onPressed: () => showLivesDialog(context, ref),
                      icon: const Icon(Icons.flash_on, size: 16),
                      label: const Text('Recargar vidas'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => context.go('/dashboard'),
                      child: const Text('Volver al Dashboard'),
                    ),
                  ] else ...[
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _showFeedback = false;
                          _selectedChoiceIndex = null;
                          _showHint = true;
                        });
                      },
                      child: const Text('Intentar de nuevo'),
                    ),
                  ],
                ],
                if (isSuccess) ...[
                  OutlinedButton(
                    onPressed: () => context.go('/dashboard'),
                    child: const Text('Volver al Dashboard'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final all = SampleLessons.allLessons;
                      final currentIdx = all.indexWhere(
                        (l) => l.id == lesson.id,
                      );
                      if (currentIdx != -1 && currentIdx + 1 < all.length) {
                        context.go('/lesson/${all[currentIdx + 1].id}');
                      } else {
                        context.go('/dashboard');
                      }
                    },
                    child: const Text('Siguiente Lección'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
