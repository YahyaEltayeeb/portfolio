import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// A high-performance, robust image widget for assets with lazy frame building,
/// lightweight skeleton placeholder, error fallback, and RepaintBoundary isolation.
///
/// Prevents unnecessary repaints on web viewports and provides a smooth loading
/// experience without blocking layout.
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
        return _ImageSkeleton(
          width: width,
          height: height,
          borderRadius: borderRadius,
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
                size: 32,
                color: AppColors.secondaryText.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 6),
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

    // Isolate rasterized image layers with RepaintBoundary for optimal Web scrolling performance
    return RepaintBoundary(child: imageWidget);
  }
}

/// A lightweight skeleton placeholder with subtle pulse while asset decodes.
class _ImageSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const _ImageSkeleton({this.width, this.height, this.borderRadius});

  @override
  State<_ImageSkeleton> createState() => _ImageSkeletonState();
}

class _ImageSkeletonState extends State<_ImageSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.04,
      end: 0.12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: widget.borderRadius ?? BorderRadius.zero,
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.6),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Subtle shimmer highlight
                ColoredBox(
                  color: AppColors.primaryCyan.withValues(
                    alpha: _animation.value,
                  ),
                ),
                child!,
              ],
            ),
          );
        },
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryCyan,
            ),
          ),
        ),
      ),
    );
  }
}
