import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../repositories/social_links_repository.dart';
import 'logo_widget.dart';

/// Slide-in mobile drawer navigation menu with frosted glass aesthetic.
class MobileDrawerMenu extends StatelessWidget {
  final ValueNotifier<int> activeIndexNotifier;
  final VoidCallback onHomeTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onHowIWorkTap;
  final VoidCallback onContactTap;

  const MobileDrawerMenu({
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
    final socialLinks = const SocialLinksRepository().getSocialLinks();

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                color: AppColors.background.withValues(alpha: 0.92),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Logo & Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LogoWidget(
                        onTap: () {
                          Navigator.of(context).pop();
                          onHomeTap();
                        },
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.primaryText,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Navigation Links
                  Expanded(
                    child: ValueListenableBuilder<int>(
                      valueListenable: activeIndexNotifier,
                      builder: (context, activeIndex, _) {
                        return ListView(
                          children: [
                            _buildDrawerItem(
                              context,
                              title: AppStrings.navHome,
                              icon: Icons.home_rounded,
                              isActive: activeIndex == 0,
                              onTap: onHomeTap,
                            ),
                            _buildDrawerItem(
                              context,
                              title: AppStrings.navSkills,
                              icon: Icons.code_rounded,
                              isActive: activeIndex == 1,
                              onTap: onSkillsTap,
                            ),
                            _buildDrawerItem(
                              context,
                              title: AppStrings.navProjects,
                              icon: Icons.folder_special_rounded,
                              isActive: activeIndex == 2,
                              onTap: onProjectsTap,
                            ),
                            _buildDrawerItem(
                              context,
                              title: AppStrings.navExperience,
                              icon: Icons.work_history_rounded,
                              isActive: activeIndex == 3,
                              onTap: onExperienceTap,
                            ),
                            _buildDrawerItem(
                              context,
                              title: AppStrings.navHowIWork,
                              icon: Icons.sync_alt_rounded,
                              isActive: activeIndex == 4,
                              onTap: onHowIWorkTap,
                            ),
                            _buildDrawerItem(
                              context,
                              title: AppStrings.navContact,
                              icon: Icons.chat_bubble_outline_rounded,
                              isActive: activeIndex == 5,
                              onTap: onContactTap,
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Social Links at Bottom (Strictly LinkedIn, GitHub, WhatsApp)
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 16),
                  Text(
                    'Connect with me',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: socialLinks.map((link) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () => AppLinks.openUrl(link.url),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: FaIcon(
                                link.icon,
                                size: 18,
                                color: AppColors.primaryCyan,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryCyan.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? AppColors.primaryCyan.withValues(alpha: 0.5)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive
                    ? AppColors.primaryCyan
                    : AppColors.secondaryText,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? AppColors.primaryCyan
                      : AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
