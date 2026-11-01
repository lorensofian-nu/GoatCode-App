import 'dart:math';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_motion.dart';

/// Lightweight canvas-based confetti celebration burst with cosmic particles
/// (neon cyan, violet, fire orange and emerald stars/discs).
class CosmicConfetti extends StatefulWidget {
  final VoidCallback? onFinished;

  const CosmicConfetti({super.key, this.onFinished});

  @override
  State<CosmicConfetti> createState() => _CosmicConfettiState();
}

class _CosmicConfettiState extends State<CosmicConfetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    final colors = [
      AppColors.secondaryCyan,
      AppColors.primaryNeonLight,
      AppColors.streakFire,
      AppColors.successGreen,
      Colors.white,
    ];

    for (int i = 0; i < 45; i++) {
      final angle = _rnd.nextDouble() * 2 * pi;
      final speed = 120 + _rnd.nextDouble() * 260;
      _particles.add(
        _Particle(
          x: 0,
          y: 0,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed - 150, // Initial upward burst
          size: 4 + _rnd.nextDouble() * 6,
          color: colors[_rnd.nextInt(colors.length)],
          rotationSpeed: (_rnd.nextDouble() - 0.5) * 10,
          isStar: _rnd.nextBool(),
        ),
      );
    }

    if (!AppMotion.isTestEnvironment) {
      _controller.forward().then((_) {
        if (mounted) widget.onFinished?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AppMotion.isTestEnvironment) return const SizedBox.shrink();

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _controller.value;
          final opacity = (1.0 - progress).clamp(0.0, 1.0);

          return Opacity(
            opacity: opacity,
            child: CustomPaint(
              size: Size.infinite,
              painter: _ConfettiPainter(
                particles: _particles,
                progress: progress,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double vx;
  final double vy;
  final double size;
  final Color color;
  final double rotationSpeed;
  final bool isStar;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.rotationSpeed,
    required this.isStar,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height * 0.4;
    final t = progress;
    final gravity = 480.0;

    for (final p in particles) {
      final currentX = centerX + p.vx * t;
      final currentY = centerY + p.vy * t + 0.5 * gravity * t * t;

      final paint = Paint()
        ..color = p.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(p.rotationSpeed * t);

      if (p.isStar) {
        // Draw small diamond/star
        final path = Path()
          ..moveTo(0, -p.size)
          ..lineTo(p.size * 0.4, 0)
          ..lineTo(0, p.size)
          ..lineTo(-p.size * 0.4, 0)
          ..close();
        canvas.drawPath(path, paint);
      } else {
        // Draw round confetti disc
        canvas.drawCircle(Offset.zero, p.size * 0.5, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
