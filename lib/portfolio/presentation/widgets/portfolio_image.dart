import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// A robust image widget for assets with loading progress and error fallback.
///
/// Prevents missing or malformed assets from throwing unhandled exceptions or
/// breaking the layout.
class PortfolioImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Alignment alignment;

  const PortfolioImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.borderRadius,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return Container(
          width: width,
          height: height,
          color: AppColors.card,
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryCyan,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: borderRadius ?? BorderRadius.zero,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                size: 36,
                color: AppColors.secondaryText.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Image unavailable',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }
}
