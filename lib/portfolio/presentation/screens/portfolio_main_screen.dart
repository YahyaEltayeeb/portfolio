import 'package:flutter/material.dart';
import '../../../core/animations/background/subtle_ambient_background.dart';
import '../../../core/utils/responsive.dart';
import '../sections/contact/contact_section.dart';
import '../sections/experience/experience_section.dart';
import '../sections/footer/footer_section.dart';
import '../sections/hero/hero_section.dart';
import '../sections/how_i_work/how_i_work_section.dart';
import '../sections/navbar/mobile_drawer_menu.dart';
import '../sections/navbar/navbar.dart';
import '../sections/projects/projects_section.dart';
import '../sections/skills/skills_section.dart';

/// Main responsive scrolling portfolio page for Yahya Mohamed.
class PortfolioMainScreen extends StatefulWidget {
  const PortfolioMainScreen({super.key});

  @override
  State<PortfolioMainScreen> createState() => _PortfolioMainScreenState();
}

class _PortfolioMainScreenState extends State<PortfolioMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int> _activeIndexNotifier = ValueNotifier<int>(0);

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _howIWorkKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  late final List<GlobalKey> _sectionKeys;

  @override
  void initState() {
    super.initState();
    _sectionKeys = [
      _heroKey,
      _skillsKey,
      _projectsKey,
      _experienceKey,
      _howIWorkKey,
      _contactKey,
    ];
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _activeIndexNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.offset < 100) {
      if (_activeIndexNotifier.value != 0) {
        _activeIndexNotifier.value = 0;
      }
      return;
    }

    int newIndex = 0;
    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      final context = key.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          final position = renderBox.localToGlobal(Offset.zero);
          if (position.dy <= 350) {
            newIndex = i;
            break;
          }
        }
      }
    }

    if (_activeIndexNotifier.value != newIndex) {
      _activeIndexNotifier.value = newIndex;
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        alignment: 0.05,
      );
    }
  }

  void _openMobileDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      endDrawer: isMobile
          ? MobileDrawerMenu(
              activeIndexNotifier: _activeIndexNotifier,
              onHomeTap: _scrollToTop,
              onSkillsTap: () => _scrollToKey(_skillsKey),
              onProjectsTap: () => _scrollToKey(_projectsKey),
              onExperienceTap: () => _scrollToKey(_experienceKey),
              onHowIWorkTap: () => _scrollToKey(_howIWorkKey),
              onContactTap: () => _scrollToKey(_contactKey),
            )
          : null,
      body: Stack(
        children: [
          // 1. Ambient Background Layer
          const Positioned.fill(child: SubtleAmbientBackground()),

          // 2. Main Scrolling Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Top spacing for floating/mobile navbar
                SizedBox(height: isMobile ? 80 : 110),

                // Section 1: Hero / About
                Container(
                  key: _heroKey,
                  child: HeroSection(
                    onViewProjectsTap: () => _scrollToKey(_projectsKey),
                  ),
                ),

                // Section 2: Skills
                Container(key: _skillsKey, child: const SkillsSection()),

                // Section 3: Projects
                Container(key: _projectsKey, child: const ProjectsSection()),

                // Section 4: Experience
                Container(
                  key: _experienceKey,
                  child: const ExperienceSection(),
                ),

                // Section 5: How I Work
                Container(key: _howIWorkKey, child: const HowIWorkSection()),

                // Section 6: Contact
                Container(key: _contactKey, child: const ContactSection()),

                // Section 7: Footer
                FooterSection(onBackToTop: _scrollToTop),
              ],
            ),
          ),

          // 3. Pinned Navbar Layer
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Navbar(
                activeIndexNotifier: _activeIndexNotifier,
                onHomeTap: _scrollToTop,
                onSkillsTap: () => _scrollToKey(_skillsKey),
                onProjectsTap: () => _scrollToKey(_projectsKey),
                onExperienceTap: () => _scrollToKey(_experienceKey),
                onHowIWorkTap: () => _scrollToKey(_howIWorkKey),
                onContactTap: () => _scrollToKey(_contactKey),
                onMobileMenuTap: _openMobileDrawer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
