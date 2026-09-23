import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'logo_widget.dart';

/// Compact mobile top app bar with YM logo and hamburger menu button.
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LogoWidget(onTap: onHomeTap),
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
