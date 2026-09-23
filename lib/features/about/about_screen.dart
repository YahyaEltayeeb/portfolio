import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../responsive/responsive_layout.dart';
import '../../widgets/glassmorphic_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(isMobile).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: AppDimensions.spacingXl),
          if (isMobile)
            _buildMobileLayout()
          else
            _buildDesktopLayout(),
        ],
      ),
    );
  }

  Widget _buildTitle(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.navAbout,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.neonCyan,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonCyan.withValues(alpha: 0.5),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _buildBio()
              .animate()
              .fadeIn(delay: 100.ms, duration: 500.ms)
              .slideX(begin: -0.05),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 2,
          child: _buildInfoCards()
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .slideX(begin: 0.05),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildBio().animate().fadeIn(delay: 100.ms, duration: 400.ms),
        const SizedBox(height: 24),
        _buildInfoCards()
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildBio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hello, I\'m ${AppStrings.developerName}',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          AppStrings.title,
          style: TextStyle(
            color: AppColors.neonOrange,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        const Text(
          'I am a passionate Flutter developer who loves building beautiful, '
          'high-performance mobile and web applications. With expertise in '
          'cross-platform development, I create seamless digital experiences '
          'that solve real-world problems.\n\n'
          'My focus areas include clean architecture, responsive design, '
          'and creating delightful user interfaces that combine aesthetics '
          'with functionality.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.8,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        // Experience highlights
        const Text(
          'What I Do',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        _buildExperienceItem(
          Icons.phone_android,
          'Mobile Development',
          'Cross-platform apps with Flutter',
          AppColors.neonCyan,
        ),
        _buildExperienceItem(
          Icons.web,
          'Web Development',
          'Responsive Flutter web applications',
          AppColors.neonOrange,
        ),
        _buildExperienceItem(
          Icons.design_services,
          'UI/UX Design',
          'Modern, clean, and accessible interfaces',
          AppColors.neonGreen,
        ),
        _buildExperienceItem(
          Icons.cloud,
          'Backend Integration',
          'Firebase, REST APIs, and cloud services',
          AppColors.neonPurple,
        ),
      ],
    );
  }

  Widget _buildExperienceItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Column(
      children: [
        GlassmorphicCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Facts',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _factItem('Location', 'Egypt'),
              _factItem('Experience', '3+ Years'),
              _factItem('Focus', 'Flutter & Dart'),
              _factItem('Education', 'Computer Science'),
              _factItem('Status', 'Open to work'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassmorphicCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Interests',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Mobile Apps',
                  'AI/ML',
                  'Clean Code',
                  'UI Design',
                  'Open Source',
                  'Tech Community',
                ].map((tag) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.neonCyan.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.neonCyan.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: AppColors.neonCyan,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _factItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
