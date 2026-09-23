import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../widgets/portfolio_image.dart';

/// Minimal, premium portrait presentation for Yahya Mohamed featuring:
/// - Single clean vertical rounded rectangle container (~24px radius)
/// - Very thin cyan-to-violet gradient border with soft shadow
/// - Visual focus on person: face, shoulders, and upper body prominently displayed
/// - Closer portrait composition using BoxFit.cover with tuned alignment
/// - Soft cyan/violet abstract gradient shape behind portrait for subtle depth
/// - Small muted caption under the portrait: "Flutter Developer • Available for Opportunities"
/// - Desktop hover: subtle 1.02 scale and gradient border brightening (280ms)
/// - Respects reduced-motion preferences (disableAnimations)
/// - Fully responsive sizing across Desktop, Tablet, and Mobile viewports
class PortraitContainer extends StatefulWidget {
  final double? size;

  const PortraitContainer({super.key, this.size});

  @override
  State<PortraitContainer> createState() => _PortraitContainerState();
}

class _PortraitContainerState extends State<PortraitContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    // Responsive card dimensions
    // Desktop: approx 340-390px wide (e.g. 360px)
    // Tablet: approx 300-340px wide (e.g. 320px)
    // Mobile: approx 240-280px wide (e.g. 260px)
    final double cardWidth = widget.size != null
        ? Responsive.value<double>(
            context,
            mobile: (widget.size! * 0.93).clamp(240.0, 280.0),
            tablet: (widget.size! * 0.85).clamp(300.0, 340.0),
            desktop: (widget.size! * 0.95).clamp(340.0, 390.0),
          )
        : Responsive.value<double>(
            context,
            mobile: 260.0,
            tablet: 320.0,
            desktop: 360.0,
          );

    // Vertical portrait aspect ratio approx 1 : 1.25
    final double cardHeight = cardWidth * 1.25;

    // Corner radius ~24px
    final borderRadius = BorderRadius.circular(24);
    final innerBorderRadius = BorderRadius.circular(22.8);

    // Backdrop offset
    const double backdropOffset = 10.0;
    const double horizontalMargin = 8.0;
    final double stackWidth = cardWidth + (horizontalMargin * 2);
    final double stackHeight = cardHeight + backdropOffset;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: SizedBox(
              width: stackWidth,
              height: stackHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 1. Single subtle decorative element: Soft cyan/violet abstract gradient shape behind portrait
                  Positioned(
                    top: backdropOffset,
                    left: horizontalMargin + 6.0,
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryCyan.withValues(alpha: 0.16),
                            AppColors.secondaryViolet.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 2. Single clean vertical rounded rectangle portrait container
                  Positioned(
                    top: 0,
                    left: horizontalMargin,
                    child: AnimatedContainer(
                      duration: disableAnimations
                          ? Duration.zero
                          : const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      width: cardWidth,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryCyan.withValues(
                              alpha: _isHovered ? 0.70 : 0.40,
                            ),
                            AppColors.secondaryViolet.withValues(
                              alpha: _isHovered ? 0.60 : 0.30,
                            ),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: _isHovered ? 24 : 18,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: AppColors.primaryCyan.withValues(
                              alpha: _isHovered ? 0.12 : 0.05,
                            ),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(
                        1.2,
                      ), // Thin gradient border
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0C1726),
                          borderRadius: innerBorderRadius,
                        ),
                        child: ClipRRect(
                          borderRadius: innerBorderRadius,
                          child: AnimatedScale(
                            scale: _isHovered && !disableAnimations
                                ? 1.02
                                : 1.0,
                            duration: disableAnimations
                                ? Duration.zero
                                : const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                            child: SizedBox(
                              width: cardWidth,
                              height: cardHeight,
                              child: Transform.scale(
                                scale: 1.42,
                                alignment: const Alignment(0.0, -0.6),
                                child: Semantics(
                                  label:
                                      'Portrait of Yahya Mohamed, Flutter Developer',
                                  child: PortfolioImage(
                                    assetPath: AppAssets.profileImage,
                                    fit: BoxFit.cover,
                                    alignment: const Alignment(0.0, -0.6),
                                    width: cardWidth,
                                    height: cardHeight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Small muted caption under the portrait
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              'Flutter Developer • Available for Opportunities',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
