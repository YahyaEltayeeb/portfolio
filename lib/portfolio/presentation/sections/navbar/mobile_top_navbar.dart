import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../models/social_link_model.dart';
import 'logo_widget.dart';

/// Compact mobile top app bar with YM logo, middle social icons, and hamburger menu.
class MobileTopNavbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onMenuTap;

  const MobileTopNavbar({
    super.key,
    required this.onHomeTap,
    required this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LogoWidget(onTap: onHomeTap),

                // Middle Social Icons: WhatsApp, GitHub, LinkedIn, Email
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    _MobileSocialIcon(
                      icon: SocialLinkModel.whatsAppIcon,
                      tooltip: AppStrings.whatsApp,
                      url: AppLinks.whatsApp,
                    ),
                    _MobileSocialIcon(
                      icon: SocialLinkModel.gitHubIcon,
                      tooltip: AppStrings.gitHub,
                      url: AppLinks.gitHub,
                    ),
                    _MobileSocialIcon(
                      icon: SocialLinkModel.linkedInIcon,
                      tooltip: AppStrings.linkedIn,
                      url: AppLinks.linkedIn,
                    ),
                    _MobileSocialIcon(
                      icon: SocialLinkModel.emailIcon,
                      tooltip: AppStrings.emailLabel,
                      url: AppLinks.email,
                    ),
                  ],
                ),

                IconButton(
                  onPressed: onMenuTap,
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: AppColors.primaryText,
                    size: 28,
                  ),
                  tooltip: 'Menu',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileSocialIcon extends StatelessWidget {
  final FaIconData icon;
  final String tooltip;
  final String url;

  const _MobileSocialIcon({
    required this.icon,
    required this.tooltip,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => AppLinks.openUrl(url),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.card.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Center(
              child: FaIcon(icon, size: 14.5, color: AppColors.primaryCyan),
            ),
          ),
        ),
      ),
    );
  }
}
