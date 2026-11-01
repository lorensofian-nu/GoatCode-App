import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/code_snippet_block.dart';

class MemoryStep {
  final int lineIndex;
  final String explanation;
  final String variableName;
  final String variableValue;
  final String variableType;
  final String? consoleOutput;

  const MemoryStep({
    required this.lineIndex,
    required this.explanation,
    required this.variableName,
    required this.variableValue,
    this.variableType = 'int',
    this.consoleOutput,
  });
}

/// Interactive step-by-step memory and code execution visualizer for adult beginner learners.
class InteractiveMemoryVisualizer extends StatefulWidget {
  final String code;
  final String lessonId;
  final double scale;
  final ValueChanged<int?>? onLineChanged;

  const InteractiveMemoryVisualizer({
    super.key,
    required this.code,
    required this.lessonId,
    this.scale = 1.0,
    this.onLineChanged,
  });

  @override
  State<InteractiveMemoryVisualizer> createState() =>
      _InteractiveMemoryVisualizerState();
}

class _InteractiveMemoryVisualizerState
    extends State<InteractiveMemoryVisualizer> {
  int _currentStepIndex = 0;
  bool _isExpanded = true;

  late List<MemoryStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = _getStepsForLesson(widget.lessonId, widget.code);
  }

  List<MemoryStep> _getStepsForLesson(String id, String code) {
    if (id == 'variables_01') {
      return const [
        MemoryStep(
          lineIndex: 0,
          explanation:
              'Paso 1: Se crea la variable "vidas" y se almacena el número 3 en la memoria.',
          variableName: 'vidas',
          variableValue: '3',
          variableType: 'int',
        ),
        MemoryStep(
          lineIndex: 1,
          explanation:
              'Paso 2: Se calcula 3 - 1 = 2 y se sobrescribe el contenido de "vidas".',
          variableName: 'vidas',
          variableValue: '2',
          variableType: 'int',
        ),
        MemoryStep(
          lineIndex: 2,
          explanation:
              'Paso 3: print() lee el valor final de la caja y lo muestra en pantalla.',
          variableName: 'vidas',
          variableValue: '2',
          variableType: 'int',
          consoleOutput: '2',
        ),
      ];
    }

    if (id == 'variables_02') {
      return const [
        MemoryStep(
          lineIndex: 0,
          explanation:
              'Paso 1: Guardamos el texto "Ada Lovelace" en la variable "nombre".',
          variableName: 'nombre',
          variableValue: '"Ada Lovelace"',
          variableType: 'String',
        ),
        MemoryStep(
          lineIndex: 1,
          explanation:
              'Paso 2: Guardamos el número decimal 36.5 en la variable "temperatura".',
          variableName: 'temperatura',
          variableValue: '36.5',
          variableType: 'double',
        ),
        MemoryStep(
          lineIndex: 2,
          explanation:
              'Paso 3: Guardamos el estado lógico "true" (verdadero) en "esMayorDeEdad".',
          variableName: 'esMayorDeEdad',
          variableValue: 'true',
          variableType: 'bool',
        ),
      ];
    }

    // Default dynamic steps generated from code lines
    final lines = widget.code
        .split('\n')
        .where((l) => l.trim().isNotEmpty && !l.trim().startsWith('//'))
        .toList();

    if (lines.isEmpty) {
      return [
        const MemoryStep(
          lineIndex: 0,
          explanation: 'Ejecución del bloque de código.',
          variableName: 'resultado',
          variableValue: 'OK',
        ),
      ];
    }

    return List.generate(lines.length, (i) {
      return MemoryStep(
        lineIndex: i,
        explanation: 'Línea ${i + 1}: ${lines[i].trim()}',
        variableName: 'estado',
        variableValue: 'Paso ${i + 1}',
      );
    });
  }

  void _nextStep() {
    setState(() {
      if (_currentStepIndex < _steps.length - 1) {
        _currentStepIndex++;
      } else {
        _currentStepIndex = 0; // Restart loop
      }
    });
    widget.onLineChanged?.call(_steps[_currentStepIndex].lineIndex);
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    final step = _steps[_currentStepIndex];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF140F26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.secondaryCyan.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Toggle
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.play_circle_fill_rounded,
                    color: AppColors.secondaryCyan,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Simulación en Vivo • Paso a Paso',
                    style: TextStyle(
                      color: AppColors.secondaryCyan,
                      fontWeight: FontWeight.w700,
                      fontSize: 14 * scale,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Paso ${_currentStepIndex + 1} de ${_steps.length}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12 * scale,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          if (_isExpanded) ...[
            const Divider(color: AppColors.surfaceBorder, height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Code view with active line highlighted
                  CodeSnippetBlock(
                    code: widget.code,
                    title: 'Ejecutor Paso a Paso',
                    activeLineIndex: step.lineIndex,
                    scale: scale,
                  ),
                  const SizedBox(height: 16),

                  // Step explanation badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF191333),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.primaryNeonLight,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            step.explanation,
                            style: AppTypography.body(scale).copyWith(
                              fontSize: 13.5 * scale,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Memory Boxes View (How computer holds data)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Caja en Memoria RAM:',
                              style: AppTypography.caption(scale).copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F0B1E),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primaryNeonLight,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryNeon.withValues(
                                      alpha: 0.25,
                                    ),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        step.variableName,
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          color: AppColors.secondaryCyan,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14 * scale,
                                        ),
                                      ),
                                      Text(
                                        '(${step.variableType})',
                                        style: TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 11 * scale,
                                        ),
                                      ),
                                    ],
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, anim) =>
                                        ScaleTransition(
                                          scale: anim,
                                          child: child,
                                        ),
                                    child: Text(
                                      step.variableValue,
                                      key: ValueKey(step.variableValue),
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        color: AppColors.streakFire,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18 * scale,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (step.consoleOutput != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Salida por Consola:',
                                style: AppTypography.caption(scale).copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.surfaceBorder,
                                  ),
                                ),
                                child: Text(
                                  '> ${step.consoleOutput}',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    color: AppColors.successGreen,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14 * scale,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Step Advance Button & Reset
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Step progress indicators (dots)
                      Row(
                        children: List.generate(_steps.length, (idx) {
                          final isActive = idx == _currentStepIndex;
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            width: isActive ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.secondaryCyan
                                  : AppColors.surfaceBorder,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNeon,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        onPressed: _nextStep,
                        icon: Icon(
                          _currentStepIndex == _steps.length - 1
                              ? Icons.replay_rounded
                              : Icons.skip_next_rounded,
                          size: 18,
                        ),
                        label: Text(
                          _currentStepIndex == _steps.length - 1
                              ? 'Reiniciar'
                              : 'Siguiente paso',
                          style: TextStyle(fontSize: 13 * scale),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
