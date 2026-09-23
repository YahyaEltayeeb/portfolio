import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../responsive/responsive_layout.dart';
import '../../widgets/side_navigation.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../city_map/city_map_screen.dart';
import '../about/about_screen.dart';
import '../skills/skills_screen.dart';
import '../contact/contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    CityMapScreen(),
    AboutScreen(),
    CityMapScreen(), // Projects (map view acts as projects overview)
    SkillsScreen(),
    SkillsScreen(), // Experience (reusing skills for now)
    ContactScreen(),
  ];

  // Mobile uses condensed navigation
  final List<int> _mobileNavMapping = [0, 2, 3, 1];

  void _onNavItemSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onMobileNavSelected(int index) {
    setState(() => _selectedIndex = _mobileNavMapping[index]);
  }

  int get _mobileSelectedIndex {
    final mapping = _mobileNavMapping.indexOf(_selectedIndex);
    return mapping != -1 ? mapping : 0;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktop: _buildDesktopLayout(),
      tablet: _buildTabletLayout(),
      mobile: _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SideNavigation(
            selectedIndex: _selectedIndex,
            onItemSelected: _onNavItemSelected,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SideNavigation(
            selectedIndex: _selectedIndex,
            onItemSelected: _onNavItemSelected,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _mobileSelectedIndex,
        onItemSelected: _onMobileNavSelected,
      ),
    );
  }
}
