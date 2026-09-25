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
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: frame != null
              ? KeyedSubtree(
                  key: const ValueKey('loaded_image'),
                  child: child,
                )
              : KeyedSubtree(
                  key: const ValueKey('image_skeleton'),
                  child: _ImageSkeleton(
                    width: width,
                    height: height,
                    borderRadius: borderRadius,
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

/// A premium, high-performance shimmer skeleton placeholder with sweeping light
/// wave while the asset decodes.
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
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _animation = Tween<double>(
      begin: -1.3,
      end: 1.3,
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
                color: AppColors.border.withValues(alpha: 0.5),
              ),
              gradient: LinearGradient(
                begin: const Alignment(-1.0, -0.3),
                end: const Alignment(1.0, 0.3),
                colors: [
                  AppColors.card,
                  const Color(0xFF15263A),
                  const Color(0xFF223C59),
                  AppColors.primaryCyan.withValues(alpha: 0.16),
                  const Color(0xFF223C59),
                  const Color(0xFF15263A),
                  AppColors.card,
                ],
                stops: const [0.0, 0.3, 0.45, 0.5, 0.55, 0.7, 1.0],
                transform: _SlidingGradientTransform(
                  slidePercent: _animation.value,
                ),
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: _calculateIconSize(),
            color: AppColors.secondaryText.withValues(alpha: 0.18),
          ),
        ),
      ),
    );
  }

  double _calculateIconSize() {
    if (widget.height != null && widget.width != null) {
      final minDim = widget.height! < widget.width! ? widget.height! : widget.width!;
      return (minDim * 0.28).clamp(16.0, 36.0);
    }
    if (widget.height != null) {
      return (widget.height! * 0.28).clamp(16.0, 36.0);
    }
    return 28.0;
  }
}

/// Applies a horizontal offset to a [LinearGradient] to produce a smooth shimmer sweep.
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
