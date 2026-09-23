import 'dart:math';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class _AmbientParticle {
  double x;
  double y;
  double vx;
  double vy;
  double radius;
  double opacity;

  _AmbientParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.opacity,
  });
}

/// A lightweight, high-performance ambient canvas background.
///
/// Features:
/// - Only 16 soft floating particles with low-cost draw operations
/// - Isolated via RepaintBoundary to avoid triggering outside widget rebuilds
/// - Automatically pauses animation when tab/app is hidden or inactive
/// - Respects system reduced-motion accessibility preferences
class SubtleAmbientBackground extends StatefulWidget {
  const SubtleAmbientBackground({super.key});

  @override
  State<SubtleAmbientBackground> createState() =>
      _SubtleAmbientBackgroundState();
}

class _SubtleAmbientBackgroundState extends State<SubtleAmbientBackground>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;
  final List<_AmbientParticle> _particles = [];
  final Random _random = Random();
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _controller.addListener(_updateParticles);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      if (_controller.isAnimating) _controller.stop();
    }
  }

  void _initParticles(Size size) {
    if (size == _lastSize && _particles.isNotEmpty) return;
    _lastSize = size;
    _particles.clear();

    // Subtle count: 16 particles for ultra-low CPU footprint
    const int count = 16;
    for (int i = 0; i < count; i++) {
      final speed = 0.08 + _random.nextDouble() * 0.18;
      final angle = _random.nextDouble() * 2 * pi;
      _particles.add(
        _AmbientParticle(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * size.height,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          radius: 1.0 + _random.nextDouble() * 1.8,
          opacity: 0.12 + _random.nextDouble() * 0.35,
        ),
      );
    }
  }

  void _updateParticles() {
    if (_lastSize == Size.zero) return;
    for (final p in _particles) {
      p.x += p.vx;
      p.y += p.vy;

      // Wrap around edges
      if (p.x < -10) p.x = _lastSize.width + 10;
      if (p.x > _lastSize.width + 10) p.x = -10;
      if (p.y < -10) p.y = _lastSize.height + 10;
      if (p.y > _lastSize.height + 10) p.y = -10;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_updateParticles);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (disableAnimations && _controller.isAnimating) {
      _controller.stop();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initParticles(size);

        return RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                size: size,
                painter: _SubtleAmbientPainter(
                  particles: _particles,
                  backgroundColor: AppColors.background,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SubtleAmbientPainter extends CustomPainter {
  final List<_AmbientParticle> particles;
  final Color backgroundColor;

  _SubtleAmbientPainter({
    required this.particles,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Solid dark background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    // 2. Subtle radial gradient glow in the top-right and center-left
    final glowPaint1 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.primaryCyan.withValues(alpha: 0.04),
              Colors.transparent,
            ],
            radius: 0.8,
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.85, size.height * 0.2),
              radius: size.width * 0.45,
            ),
          );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint1);

    final glowPaint2 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.secondaryViolet.withValues(alpha: 0.03),
              Colors.transparent,
            ],
            radius: 0.8,
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.15, size.height * 0.7),
              radius: size.width * 0.5,
            ),
          );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint2);

    // 3. Ambient particles
    final particlePaint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      particlePaint.color = AppColors.glow.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(p.x, p.y), p.radius, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SubtleAmbientPainter oldDelegate) => true;
}
