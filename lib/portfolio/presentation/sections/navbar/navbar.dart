import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';
import 'desktop_floating_navbar.dart';
import 'mobile_top_navbar.dart';

/// Responsive Navbar controller that renders DesktopFloatingNavbar or MobileTopNavbar.
class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<int> activeIndexNotifier;
  final VoidCallback onHomeTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onHowIWorkTap;
  final VoidCallback onContactTap;
  final VoidCallback onMobileMenuTap;

  const Navbar({
    super.key,
    required this.activeIndexNotifier,
    required this.onHomeTap,
    required this.onSkillsTap,
    required this.onProjectsTap,
    required this.onExperienceTap,
    required this.onHowIWorkTap,
    required this.onContactTap,
    required this.onMobileMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return MobileTopNavbar(onHomeTap: onHomeTap, onMenuTap: onMobileMenuTap);
    }

    return DesktopFloatingNavbar(
      activeIndexNotifier: activeIndexNotifier,
      onHomeTap: onHomeTap,
      onSkillsTap: onSkillsTap,
      onProjectsTap: onProjectsTap,
      onExperienceTap: onExperienceTap,
      onHowIWorkTap: onHowIWorkTap,
      onContactTap: onContactTap,
    );
  }
}
