import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import 'neon_glow_widget.dart';

class SideNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SideNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.map_outlined, label: AppStrings.navCityMap),
    _NavItem(icon: Icons.person_outline, label: AppStrings.navAbout),
    _NavItem(icon: Icons.work_outline, label: AppStrings.navProjects),
    _NavItem(icon: Icons.code, label: AppStrings.navSkills),
    _NavItem(icon: Icons.timeline, label: AppStrings.navExperience),
    _NavItem(icon: Icons.mail_outline, label: AppStrings.navContact),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.sideNavWidth,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.spacingXl),
          // Logo / Brand
          _buildBrand(),
          const SizedBox(height: AppDimensions.spacingXl),
          // Nav Items
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingSm,
              ),
              itemBuilder: (context, index) {
                return _buildNavItem(index);
              },
            ),
          ),
          // Social Links
          _buildSocialLinks(),
          const SizedBox(height: AppDimensions.spacingMd),
          // Download CV
          _buildDownloadCVButton(),
          const SizedBox(height: AppDimensions.spacingLg),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: const Icon(
              Icons.code,
              color: AppColors.neonCyan,
              size: 28,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          const NeonText(
            text: AppStrings.developerName,
            glowColor: AppColors.neonCyan,
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          const Text(
            AppStrings.title,
            style: TextStyle(
              color: AppColors.neonOrange,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          const Text(
            AppStrings.bio,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _items[index];
    final isSelected = index == selectedIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onItemSelected(index),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: AppDimensions.animFast),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
              vertical: AppDimensions.spacingSm + 4,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.neonCyan.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: isSelected
                  ? Border.all(
                      color: AppColors.neonCyan.withValues(alpha: 0.3))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color:
                      isSelected ? AppColors.neonCyan : AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.spacingSm + 4),
                Text(
                  item.label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.neonCyan
                        : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _socialIcon(Icons.code),
          const SizedBox(width: AppDimensions.spacingMd),
          _socialIcon(Icons.work_outline),
          const SizedBox(width: AppDimensions.spacingMd),
          _socialIcon(Icons.alternate_email),
          const SizedBox(width: AppDimensions.spacingMd),
          _socialIcon(Icons.mail_outline),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Icon(
      icon,
      size: 18,
      color: AppColors.textMuted,
    );
  }

  Widget _buildDownloadCVButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download, size: 16),
          label: const Text(AppStrings.downloadCV, style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: const BorderSide(color: AppColors.glassBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
