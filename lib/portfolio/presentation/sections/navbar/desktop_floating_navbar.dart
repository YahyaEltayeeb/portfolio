import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_typography.dart';
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
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1100),
        margin: const EdgeInsets.only(top: 20, left: 24, right: 24),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LogoWidget(onTap: onHomeTap),
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
                          ),
                          const SizedBox(width: 6),
                          _NavItem(
                            title: AppStrings.navSkills,
                            isActive: activeIndex == 1,
                            onTap: onSkillsTap,
                          ),
                          const SizedBox(width: 6),
                          _NavItem(
                            title: AppStrings.navProjects,
                            isActive: activeIndex == 2,
                            onTap: onProjectsTap,
                          ),
                          const SizedBox(width: 6),
                          _NavItem(
                            title: AppStrings.navExperience,
                            isActive: activeIndex == 3,
                            onTap: onExperienceTap,
                          ),
                          const SizedBox(width: 6),
                          _NavItem(
                            title: AppStrings.navHowIWork,
                            isActive: activeIndex == 4,
                            onTap: onHowIWorkTap,
                          ),
                          const SizedBox(width: 6),
                          _NavItem(
                            title: AppStrings.navContact,
                            isActive: activeIndex == 5,
                            onTap: onContactTap,
                            isButton: true,
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
  final bool isButton;

  const _NavItem({
    required this.title,
    required this.isActive,
    required this.onTap,
    this.isButton = false,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isButton) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.isActive || _isHovered
                  ? AppColors.primaryCyan
                  : AppColors.primaryCyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryCyan, width: 1),
            ),
            child: Text(
              widget.title,
              style: AppTypography.heading(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: widget.isActive || _isHovered
                    ? AppColors.background
                    : AppColors.primaryCyan,
              ),
            ),
          ),
        ),
      );
    }

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
