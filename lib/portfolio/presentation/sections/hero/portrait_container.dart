import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../widgets/portfolio_image.dart';

/// Layered Glass portrait presentation for Yahya Mohamed featuring:
/// - Transparent portrait cutout with full uncropped silhouette (head, shoulders, arms, suit)
/// - Two offset translucent glass panels behind the portrait:
///   1. Cyan/blue panel rotated -2 degrees
///   2. Violet/blue panel rotated +2 degrees
/// - Rounded corners around 32px
/// - Thin low-opacity borders and subtle soft glow
/// - Subtle floating animation strictly on the panels
/// - Zero unnecessary widget rebuilds, respects reduced-motion and mobile performance
class PortraitContainer extends StatefulWidget {
  final double? size;

  const PortraitContainer({super.key, this.size});

  @override
  State<PortraitContainer> createState() => _PortraitContainerState();
}

class _PortraitContainerState extends State<PortraitContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    _floatAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final isMobile = Responsive.isMobile(context);

    if ((disableAnimations || isMobile) && _controller.isAnimating) {
      _controller.stop();
    } else if (!disableAnimations && !isMobile && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    // Responsive dimensions preserving exact portrait proportions
    final double portraitWidth;
    final double portraitHeight;
    final double panelWidth;
    final double panelHeight;

    if (isMobile) {
      portraitWidth = 240.0;
      portraitHeight = 340.0;
      panelWidth = 200.0;
      panelHeight = 280.0;
    } else if (isTablet) {
      portraitWidth = 290.0;
      portraitHeight = 410.0;
      panelWidth = 245.0;
      panelHeight = 345.0;
    } else {
      // Desktop
      portraitWidth = 340.0;
      portraitHeight = 480.0;
      panelWidth = 295.0;
      panelHeight = 415.0;
    }

    final double stackWidth = portraitWidth + 36.0;
    final double stackHeight = portraitHeight + 20.0;

    // Glass panel rotation (0 on mobile to prevent overflow)
    final double cyanAngle = isMobile ? 0.0 : -2.0 * math.pi / 180.0;
    final double violetAngle = isMobile ? 0.0 : 2.0 * math.pi / 180.0;

    final borderRadius = BorderRadius.circular(32.0);

    // Pre-build static panel 1 (Cyan/blue translucent glass)
    final cyanPanel = Container(
      width: panelWidth,
      height: panelHeight,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryCyan.withValues(alpha: 0.16),
            AppColors.primaryCyan.withValues(alpha: 0.04),
            const Color(0xFF0C1929).withValues(alpha: 0.45),
          ],
        ),
        border: Border.all(
          color: AppColors.primaryCyan.withValues(alpha: 0.30),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCyan.withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );

    // Pre-build static panel 2 (Violet/blue translucent glass)
    final violetPanel = Container(
      width: panelWidth,
      height: panelHeight,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.secondaryViolet.withValues(alpha: 0.16),
            AppColors.secondaryViolet.withValues(alpha: 0.04),
            const Color(0xFF0C1929).withValues(alpha: 0.45),
          ],
        ),
        border: Border.all(
          color: AppColors.secondaryViolet.withValues(alpha: 0.30),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryViolet.withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );

    // Pre-build transparent portrait cutout (uncropped)
    final portraitImage = SizedBox(
      width: portraitWidth,
      height: portraitHeight,
      child: Semantics(
        label: 'Portrait of Yahya Mohamed, Flutter Developer',
        child: const PortfolioImage(
          assetPath: AppAssets.profileImage,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );

    return Center(
      child: SizedBox(
        width: stackWidth,
        height: stackHeight,
        child: AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, _) {
            final double animVal = (disableAnimations || isMobile)
                ? 0.5
                : _floatAnimation.value;

            // Very subtle opposing floating animation strictly on the panels:
            // Cyan panel: ~3.2px vertical movement (+1.6px to -1.6px)
            final double cyanDy = 1.6 - (3.2 * animVal);
            // Violet panel: ~3.2px opposing vertical movement (-1.6px to +1.6px)
            final double violetDy = -1.6 + (3.2 * animVal);

            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // 1. Violet/blue translucent glass panel rotated +2 degrees
                Transform.translate(
                  offset: Offset(
                    isMobile ? 3.0 : 8.0,
                    (isMobile ? 3.0 : 6.0) + violetDy,
                  ),
                  child: Transform.rotate(
                    angle: violetAngle,
                    child: violetPanel,
                  ),
                ),

                // 2. Cyan/blue translucent glass panel rotated -2 degrees
                Transform.translate(
                  offset: Offset(
                    isMobile ? -3.0 : -8.0,
                    (isMobile ? -2.0 : -4.0) + cyanDy,
                  ),
                  child: Transform.rotate(angle: cyanAngle, child: cyanPanel),
                ),

                // 3. Transparent cutout portrait in front (grounded and uncropped)
                portraitImage,
              ],
            );
          },
        ),
      ),
    );
  }
}
