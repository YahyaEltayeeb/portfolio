import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class NeonGlow extends StatelessWidget {
  final Widget child;
  final Color color;
  final double spread;
  final double blur;

  const NeonGlow({
    super.key,
    required this.child,
    this.color = AppColors.neonCyan,
    this.spread = 2,
    this.blur = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            spreadRadius: spread,
            blurRadius: blur,
          ),
        ],
      ),
      child: child,
    );
  }
}

class NeonText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color glowColor;

  const NeonText({
    super.key,
    required this.text,
    this.style,
    this.glowColor = AppColors.neonCyan,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (style ?? Theme.of(context).textTheme.headlineMedium)?.copyWith(
        shadows: [
          Shadow(
            color: glowColor.withValues(alpha: 0.5),
            blurRadius: 8,
          ),
          Shadow(
            color: glowColor.withValues(alpha: 0.3),
            blurRadius: 16,
          ),
        ],
      ),
    );
  }
}
