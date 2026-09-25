import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/spacing.dart';
import '../../../repositories/social_links_repository.dart';

class HeroContent extends StatelessWidget {
  final VoidCallback onViewProjectsTap;

  const HeroContent({super.key, required this.onViewProjectsTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final socialLinks = const SocialLinksRepository().getSocialLinks();

    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Availability / Tagline Badge
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        //   decoration: BoxDecoration(
        //     color: AppColors.primaryCyan.withValues(alpha: 0.1),
        //     borderRadius: BorderRadius.circular(20),
        //     border: Border.all(
        //       color: AppColors.primaryCyan.withValues(alpha: 0.35),
        //     ),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Container(
        //         width: 8,
        //         height: 8,
        //         decoration: const BoxDecoration(
        //           color: AppColors.success,
        //           shape: BoxShape.circle,
        //         ),
        //       ),
        //       const SizedBox(width: 8),
        //       Flexible(
        //         child: Text(
        //           AppStrings.heroTagline,
        //           style: AppTypography.heading(
        //             fontSize: 12,
        //             fontWeight: FontWeight.w600,
        //             color: AppColors.primaryCyan,
        //             letterSpacing: 0.2,
        //           ),
        //           textAlign: isMobile ? TextAlign.center : TextAlign.start,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // verticalSpace(16),

        // Greeting
        Text(
          AppStrings.greeting,
          style: AppTypography.heading(
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryText,
          ),
        ),
        verticalSpace(6),

        // Name
        Text(
          AppStrings.name,
          style: AppTypography.heading(
            fontSize: isMobile ? 36 : 52,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryText,
            letterSpacing: -1,
            height: 1.1,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        verticalSpace(8),

        // Title
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.primaryCyan, AppColors.glow],
          ).createShader(bounds),
          child: Text(
            AppStrings.title,
            style: AppTypography.heading(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          ),
        ),
        verticalSpace(16),

        // Bio Description
        Text(
          AppStrings.aboutDescription,
          style: AppTypography.body(
            fontSize: isMobile ? 14 : 15,
            color: AppColors.secondaryText,
            height: 1.6,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        verticalSpace(28),

        // Action Buttons Row
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            // "View Projects" Primary Button
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onViewProjectsTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCyan,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryCyan.withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.viewProjects,
                        style: AppTypography.heading(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.background,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: AppColors.background,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // "Download CV" Outlined Button
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => AppLinks.downloadCv(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryCyan.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.download_rounded,
                        size: 18,
                        color: AppColors.primaryCyan,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.downloadCv,
                        style: AppTypography.heading(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryCyan,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(28),

        // Social Links (Strictly LinkedIn, GitHub, WhatsApp)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: socialLinks.map((link) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _SocialIconButton(
                icon: link.icon,
                tooltip: link.name,
                onTap: () => AppLinks.openUrl(link.url),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final FaIconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.primaryCyan.withValues(alpha: 0.15)
                  : AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isHovered ? AppColors.primaryCyan : AppColors.border,
                width: 1,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.glow.withValues(alpha: 0.25),
                        blurRadius: 12,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: FaIcon(
                widget.icon,
                size: 18,
                color: _isHovered
                    ? AppColors.primaryCyan
                    : AppColors.secondaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
