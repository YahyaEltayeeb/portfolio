import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import 'portfolio_image.dart';

/// Fullscreen lightbox image viewer dialog with keyboard navigation and zoom.
class FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String title;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
    required this.title,
  });

  /// Static helper to open the viewer with smooth fade transition.
  static Future<void> show(
    BuildContext context, {
    required List<String> images,
    int initialIndex = 0,
    required String title,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss lightbox',
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return FullScreenImageViewer(
          images: images,
          initialIndex: initialIndex,
          title: title,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late int _currentIndex;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentIndex < widget.images.length - 1) {
      setState(() => _currentIndex++);
    } else {
      // Loop to beginning
      setState(() => _currentIndex = 0);
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    } else {
      // Loop to end
      setState(() => _currentIndex = widget.images.length - 1);
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _next();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _previous();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        Navigator.of(context).pop();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.images.length > 1;

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Frosted background blur
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // Top Header Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title & Counter
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                widget.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cardHover,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                '${_currentIndex + 1} / ${widget.images.length}',
                                style: const TextStyle(
                                  color: AppColors.primaryCyan,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Close Button (with Escape reminder on desktop)
                      IconButton(
                        tooltip: 'Close (Esc)',
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.card.withValues(alpha: 0.8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: AppColors.primaryText,
                            size: 20,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Image Display (InteractiveViewer for zoom/pan)
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 768;
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 72,
                      bottom: isNarrow ? 60 : 72,
                      left: isNarrow ? 16 : 64,
                      right: isNarrow ? 16 : 64,
                    ),
                    child: Center(
                      child: InteractiveViewer(
                        maxScale: 4.0,
                        minScale: 0.8,
                        child: PortfolioImage(
                          assetPath: widget.images[_currentIndex],
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Previous Button
            if (hasMultiple)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    tooltip: 'Previous (←)',
                    icon: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.card.withValues(alpha: 0.85),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.primaryText,
                        size: 28,
                      ),
                    ),
                    onPressed: _previous,
                  ),
                ),
              ),

            // Next Button
            if (hasMultiple)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    tooltip: 'Next (→)',
                    icon: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.card.withValues(alpha: 0.85),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.primaryText,
                        size: 28,
                      ),
                    ),
                    onPressed: _next,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
