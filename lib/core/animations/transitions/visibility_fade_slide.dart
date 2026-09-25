import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Wraps child in a fade and slight slide-up entrance animation triggered
/// once when the widget becomes visible in the viewport.
class VisibilityFadeSlide extends StatefulWidget {
  final Widget child;
  final String visibilityKey;
  final Duration duration;
  final double verticalOffset;
  final Duration delay;

  const VisibilityFadeSlide({
    super.key,
    required this.child,
    required this.visibilityKey,
    this.duration = const Duration(milliseconds: 600),
    this.verticalOffset = 30.0,
    this.delay = Duration.zero,
  });

  @override
  State<VisibilityFadeSlide> createState() => _VisibilityFadeSlideState();
}

class _VisibilityFadeSlideState extends State<VisibilityFadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.verticalOffset / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // For top hero-section, trigger immediately so content renders without waiting for VisibilityDetector interval
    if (widget.visibilityKey == 'hero-section') {
      _hasTriggered = true;
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_hasTriggered) return;
    if (info.visibleFraction > 0.15) {
      _hasTriggered = true;
      if (widget.delay == Duration.zero) {
        if (mounted) _controller.forward();
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.visibilityKey),
      onVisibilityChanged: _onVisibilityChanged,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(position: _slideAnimation, child: widget.child),
      ),
    );
  }
}
