import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../repositories/social_links_repository.dart';
import '../navbar/logo_widget.dart';

class FooterSection extends StatelessWidget {
  final VoidCallback onBackToTop;

  const FooterSection({super.key, required this.onBackToTop});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final socialLinks = const SocialLinksRepository().getSocialLinks();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.sectionBackground,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 36,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Top Row: Logo, Social Icons, Back to Top
              if (isMobile)
                Column(
                  children: [
                    LogoWidget(onTap: onBackToTop),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: socialLinks.map((link) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: IconButton(
                            onPressed: () => AppLinks.openUrl(link.url),
                            icon: FaIcon(
                              link.icon,
                              size: 18,
                              color: AppColors.secondaryText,
                            ),
                            tooltip: link.name,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    _BackToTopButton(onTap: onBackToTop),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LogoWidget(onTap: onBackToTop),
                    Row(
                      children: socialLinks.map((link) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: IconButton(
                            onPressed: () => AppLinks.openUrl(link.url),
                            icon: FaIcon(
                              link.icon,
                              size: 18,
                              color: AppColors.secondaryText,
                            ),
                            tooltip: link.name,
                          ),
                        );
                      }).toList(),
                    ),
                    _BackToTopButton(onTap: onBackToTop),
                  ],
                ),
              const SizedBox(height: 24),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 20),

              // Bottom Copyright
              Text(
                AppStrings.copyright,
                style: AppTypography.body(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackToTopButton extends StatefulWidget {
  final VoidCallback onTap;

  const _BackToTopButton({required this.onTap});

  @override
  State<_BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<_BackToTopButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.primaryCyan.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? AppColors.primaryCyan : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_upward_rounded,
                size: 16,
                color: _isHovered
                    ? AppColors.primaryCyan
                    : AppColors.secondaryText,
              ),
              const SizedBox(width: 6),
              Text(
                AppStrings.backToTop,
                style: AppTypography.heading(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _isHovered
                      ? AppColors.primaryCyan
                      : AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
