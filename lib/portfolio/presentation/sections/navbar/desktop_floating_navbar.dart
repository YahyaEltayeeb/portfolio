import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../models/social_link_model.dart';
import 'logo_widget.dart';

class DesktopFloatingNavbar extends StatelessWidget {
  final ValueNotifier<int> activeIndexNotifier;
  final VoidCallback onHomeTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onHowIWorkTap;
  final VoidCallback onContactTap;

  const DesktopFloatingNavbar({
    super.key,
    required this.activeIndexNotifier,
    required this.onHomeTap,
    required this.onSkillsTap,
    required this.onProjectsTap,
    required this.onExperienceTap,
    required this.onHowIWorkTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool isCompact = screenWidth < 1200;
    final bool showSocialIcons = screenWidth >= 960;

    final double navItemPadding = isCompact ? 8.0 : 12.0;
    final double navItemSpacing = isCompact ? 3.0 : 5.0;
    final double socialIconSize = isCompact ? 30.0 : 34.0;
    final double socialIconSpacing = isCompact ? 4.0 : 6.0;
    final double socialIconFontSize = isCompact ? 13.0 : 14.5;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1100),
        margin: EdgeInsets.only(
          top: isCompact ? 14 : 20,
          left: isCompact ? 16 : 24,
          right: isCompact ? 16 : 24,
        ),
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.8),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isCompact ? 12 : 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LogoWidget(onTap: onHomeTap),

                  // Pinned Social Icons: LinkedIn, GitHub, WhatsApp, Email
                  if (showSocialIcons)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _DesktopSocialIcon(
                          icon: SocialLinkModel.linkedInIcon,
                          tooltip: AppStrings.linkedIn,
                          url: AppLinks.linkedIn,
                          size: socialIconSize,
                          iconSize: socialIconFontSize,
                        ),
                        SizedBox(width: socialIconSpacing),
                        _DesktopSocialIcon(
                          icon: SocialLinkModel.gitHubIcon,
                          tooltip: AppStrings.gitHub,
                          url: AppLinks.gitHub,
                          size: socialIconSize,
                          iconSize: socialIconFontSize,
                        ),
                        SizedBox(width: socialIconSpacing),
                        _DesktopSocialIcon(
                          icon: SocialLinkModel.whatsAppIcon,
                          tooltip: AppStrings.whatsApp,
                          url: AppLinks.whatsApp,
                          size: socialIconSize,
                          iconSize: socialIconFontSize,
                        ),
                        SizedBox(width: socialIconSpacing),
                        _DesktopSocialIcon(
                          icon: SocialLinkModel.emailIcon,
                          tooltip: AppStrings.emailLabel,
                          url: AppLinks.email,
                          size: socialIconSize,
                          iconSize: socialIconFontSize,
                        ),
                      ],
                    ),

                  ValueListenableBuilder<int>(
                    valueListenable: activeIndexNotifier,
                    builder: (context, activeIndex, _) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _NavItem(
                            title: AppStrings.navHome,
                            isActive: activeIndex == 0,
                            onTap: onHomeTap,
                            horizontalPadding: navItemPadding,
                          ),
                          SizedBox(width: navItemSpacing),
                          _NavItem(
                            title: AppStrings.navSkills,
                            isActive: activeIndex == 1,
                            onTap: onSkillsTap,
                            horizontalPadding: navItemPadding,
                          ),
                          SizedBox(width: navItemSpacing),
                          _NavItem(
                            title: AppStrings.navProjects,
                            isActive: activeIndex == 2,
                            onTap: onProjectsTap,
                            horizontalPadding: navItemPadding,
                          ),
                          SizedBox(width: navItemSpacing),
                          _NavItem(
                            title: AppStrings.navExperience,
                            isActive: activeIndex == 3,
                            onTap: onExperienceTap,
                            horizontalPadding: navItemPadding,
                          ),
                          SizedBox(width: navItemSpacing),
                          _NavItem(
                            title: AppStrings.navHowIWork,
                            isActive: activeIndex == 4,
                            onTap: onHowIWorkTap,
                            horizontalPadding: navItemPadding,
                          ),
                          SizedBox(width: navItemSpacing),
                          _NavItem(
                            title: AppStrings.navContact,
                            isActive: activeIndex == 5,
                            onTap: onContactTap,
                            horizontalPadding: navItemPadding,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  final double horizontalPadding;

  const _NavItem({
    required this.title,
    required this.isActive,
    required this.onTap,
    this.horizontalPadding = 14,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
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
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.primaryCyan.withValues(alpha: 0.15)
                : (_isHovered
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isActive
                  ? AppColors.primaryCyan.withValues(alpha: 0.4)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            widget.title,
            style: AppTypography.heading(
              fontSize: 13,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              color: widget.isActive
                  ? AppColors.primaryCyan
                  : (_isHovered
                        ? AppColors.primaryText
                        : AppColors.secondaryText),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopSocialIcon extends StatefulWidget {
  final FaIconData icon;
  final String tooltip;
  final String url;
  final double size;
  final double iconSize;

  const _DesktopSocialIcon({
    required this.icon,
    required this.tooltip,
    required this.url,
    this.size = 36,
    this.iconSize = 15,
  });

  @override
  State<_DesktopSocialIcon> createState() => _DesktopSocialIconState();
}

class _DesktopSocialIconState extends State<_DesktopSocialIcon> {
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
          onTap: () => AppLinks.openUrl(widget.url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.primaryCyan.withValues(alpha: 0.15)
                  : AppColors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isHovered
                    ? AppColors.primaryCyan
                    : AppColors.border.withValues(alpha: 0.8),
                width: 1,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.primaryCyan.withValues(alpha: 0.25),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: FaIcon(
                widget.icon,
                size: widget.iconSize,
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
