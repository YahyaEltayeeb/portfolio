import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MapBackgroundWidget extends StatelessWidget {
  final Widget child;

  const MapBackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // City skyline background
        Positioned.fill(
          child: CustomPaint(
            painter: _CitySkylinePainter(),
            size: Size.infinite,
          ),
        ),
        // Subtle overlay for readability (lighter than before)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  AppColors.background.withValues(alpha: 0.25),
                  AppColors.background.withValues(alpha: 0.45),
                  AppColors.background.withValues(alpha: 0.65),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        // Grid lines
        Positioned.fill(
          child: CustomPaint(painter: _GridPainter()),
        ),
        // Glow spots
        Positioned.fill(
          child: CustomPaint(painter: _GlowSpotsPainter()),
        ),
        // Content
        child,
      ],
    );
  }
}

class _CitySkylinePainter extends CustomPainter {
  final Random _rng = Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    _drawSky(canvas, size);
    _drawBackBuildings(canvas, size);
    _drawMiddleBuildings(canvas, size);
    _drawFrontBuildings(canvas, size);
    _drawRoads(canvas, size);
  }

  void _drawSky(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF020810),
          Color(0xFF071222),
          Color(0xFF0A1A30),
          Color(0xFF081420),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Stars
    for (int i = 0; i < 50; i++) {
      final x = _rng.nextDouble() * size.width;
      final y = _rng.nextDouble() * size.height * 0.4;
      final r = 0.3 + _rng.nextDouble() * 0.8;
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()..color = Colors.white.withValues(alpha: 0.1 + _rng.nextDouble() * 0.2),
      );
    }
  }

  /// Far background buildings (small, dark)
  void _drawBackBuildings(Canvas canvas, Size size) {
    final baseY = size.height * 0.45;
    final count = (size.width / 18).floor();

    for (int i = 0; i < count; i++) {
      final x = i * size.width / count;
      final w = 12.0 + _rng.nextDouble() * 14;
      final h = 30.0 + _rng.nextDouble() * 100;
      final y = baseY - h;

      canvas.drawRect(
        Rect.fromLTWH(x, y, w, h + size.height - baseY),
        Paint()..color = Color.fromRGBO(8, 14, 24, 1),
      );

      // Tiny windows
      for (double wy = y + 4; wy < baseY; wy += 5) {
        for (double wx = x + 2; wx < x + w - 2; wx += 4) {
          if (_rng.nextDouble() > 0.55) {
            final c = _rng.nextDouble() > 0.85
                ? AppColors.neonOrange.withValues(alpha: 0.3)
                : const Color(0xFFFFE8A0).withValues(alpha: 0.15 + _rng.nextDouble() * 0.15);
            canvas.drawRect(
              Rect.fromLTWH(wx, wy, 1.8, 1.8),
              Paint()..color = c,
            );
          }
        }
      }
    }
  }

  /// Middle layer buildings (medium, more detail)
  void _drawMiddleBuildings(Canvas canvas, Size size) {
    final baseY = size.height * 0.55;
    final count = (size.width / 30).floor();

    for (int i = 0; i < count; i++) {
      final x = i * size.width / count + _rng.nextDouble() * 10;
      final w = 20.0 + _rng.nextDouble() * 25;
      final h = 80.0 + _rng.nextDouble() * 160;
      final y = baseY - h;

      // Building body
      final bodyColor = Color.fromRGBO(
        10 + _rng.nextInt(8),
        16 + _rng.nextInt(10),
        28 + _rng.nextInt(12),
        1,
      );
      canvas.drawRect(
        Rect.fromLTWH(x, y, w, h + size.height - baseY),
        Paint()..color = bodyColor,
      );

      // Edge glow
      canvas.drawRect(
        Rect.fromLTWH(x, y, w, h + size.height - baseY),
        Paint()
          ..color = AppColors.neonCyan.withValues(alpha: 0.04)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );

      // Windows
      for (double wy = y + 5; wy < baseY; wy += 7) {
        for (double wx = x + 3; wx < x + w - 3; wx += 5.5) {
          if (_rng.nextDouble() > 0.4) {
            Color wColor;
            final roll = _rng.nextDouble();
            if (roll > 0.9) {
              wColor = AppColors.neonCyan.withValues(alpha: 0.4 + _rng.nextDouble() * 0.3);
            } else if (roll > 0.8) {
              wColor = AppColors.neonOrange.withValues(alpha: 0.35 + _rng.nextDouble() * 0.25);
            } else if (roll > 0.7) {
              wColor = AppColors.neonPurple.withValues(alpha: 0.25 + _rng.nextDouble() * 0.2);
            } else {
              wColor = const Color(0xFFFFE8A0).withValues(alpha: 0.15 + _rng.nextDouble() * 0.25);
            }
            canvas.drawRect(
              Rect.fromLTWH(wx, wy, 2.5, 3),
              Paint()..color = wColor,
            );
          }
        }
      }

      // Rooftop antenna/light
      if (_rng.nextDouble() > 0.6) {
        final antennaColor = _rng.nextDouble() > 0.5
            ? AppColors.neonCyan
            : AppColors.neonPink;
        canvas.drawLine(
          Offset(x + w / 2, y),
          Offset(x + w / 2, y - 8 - _rng.nextDouble() * 10),
          Paint()
            ..color = antennaColor.withValues(alpha: 0.5)
            ..strokeWidth = 0.8,
        );
        canvas.drawCircle(
          Offset(x + w / 2, y - 8 - _rng.nextDouble() * 10),
          1.5,
          Paint()..color = antennaColor.withValues(alpha: 0.7),
        );
      }
    }
  }

  /// Front layer buildings (large, closest to viewer)
  void _drawFrontBuildings(Canvas canvas, Size size) {
    final baseY = size.height * 0.7;
    final count = (size.width / 50).floor();

    for (int i = 0; i < count; i++) {
      final x = i * size.width / count + _rng.nextDouble() * 15;
      final w = 30.0 + _rng.nextDouble() * 35;
      final h = 100.0 + _rng.nextDouble() * 200;
      final y = baseY - h;

      // Dark building body
      canvas.drawRect(
        Rect.fromLTWH(x, y, w, size.height - y),
        Paint()..color = Color.fromRGBO(6, 10, 18, 0.9),
      );

      // Neon edge on top
      final edgeColor = [
        AppColors.neonCyan,
        AppColors.neonPurple,
        AppColors.neonOrange,
      ][_rng.nextInt(3)];

      canvas.drawLine(
        Offset(x, y),
        Offset(x + w, y),
        Paint()
          ..color = edgeColor.withValues(alpha: 0.2)
          ..strokeWidth = 1.5,
      );

      // Big windows / panels
      for (double wy = y + 8; wy < size.height - 20; wy += 10) {
        for (double wx = x + 4; wx < x + w - 4; wx += 7) {
          if (_rng.nextDouble() > 0.35) {
            final roll = _rng.nextDouble();
            Color wColor;
            if (roll > 0.85) {
              wColor = AppColors.neonCyan.withValues(alpha: 0.3 + _rng.nextDouble() * 0.3);
            } else if (roll > 0.75) {
              wColor = AppColors.neonOrange.withValues(alpha: 0.25 + _rng.nextDouble() * 0.3);
            } else {
              wColor = const Color(0xFFFFE8A0).withValues(alpha: 0.1 + _rng.nextDouble() * 0.2);
            }
            canvas.drawRect(
              Rect.fromLTWH(wx, wy, 3.5, 4.5),
              Paint()..color = wColor,
            );
          }
        }
      }
    }

    // Neon signs on some buildings
    _drawBigNeonSign(canvas, size.width * 0.15, baseY - 60, 'NEON', AppColors.neonPurple);
    _drawBigNeonSign(canvas, size.width * 0.65, baseY - 90, '', AppColors.neonOrange);
    _drawBigNeonSign(canvas, size.width * 0.85, baseY - 45, '', AppColors.neonCyan);
  }

  void _drawBigNeonSign(Canvas canvas, double x, double y, String text, Color color) {
    // Glow behind
    canvas.drawRect(
      Rect.fromLTWH(x - 2, y - 2, 30, 8),
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // Sign body
    canvas.drawRect(
      Rect.fromLTWH(x, y, 26, 5),
      Paint()..color = color.withValues(alpha: 0.6),
    );
    // Brighter line
    canvas.drawRect(
      Rect.fromLTWH(x + 2, y + 1.5, 22, 2),
      Paint()..color = color.withValues(alpha: 0.9),
    );
  }

  void _drawRoads(Canvas canvas, Size size) {
    // Horizontal road
    final roadY = size.height * 0.78;
    canvas.drawRect(
      Rect.fromLTWH(0, roadY, size.width, 3),
      Paint()..color = AppColors.neonCyan.withValues(alpha: 0.06),
    );
    // Bottom area - dark ground
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.85, size.width, size.height * 0.15),
      Paint()..color = const Color(0xFF040810),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonCyan.withValues(alpha: 0.015)
      ..strokeWidth = 0.5;

    const spacing = 50.0;
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlowSpotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Central cyan glow
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.35),
      size.width * 0.15,
      Paint()
        ..color = AppColors.neonCyan.withValues(alpha: 0.03)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
    );
    // Left purple glow
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.5),
      120,
      Paint()
        ..color = AppColors.neonPurple.withValues(alpha: 0.04)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );
    // Right orange glow
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.55),
      100,
      Paint()
        ..color = AppColors.neonOrange.withValues(alpha: 0.03)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25),
    );
    // Bottom cyan road glow
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.72, size.width, 30),
      Paint()
        ..color = AppColors.neonCyan.withValues(alpha: 0.02)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
