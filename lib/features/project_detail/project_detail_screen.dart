import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../models/project_model.dart';
import '../../responsive/responsive_layout.dart';
import 'widgets/feature_list_widget.dart';
import 'widgets/tech_chip_widget.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectModel project;
  final Color accentColor;

  const ProjectDetailScreen({
    super.key,
    required this.project,
    required this.accentColor,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isMobile),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 16 : 32),
                child: isMobile
                    ? _buildMobileContent()
                    : _buildDesktopContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            color: AppColors.textSecondary,
          ),
          const Spacer(),
          if (project.githubUrl != null)
            IconButton(
              onPressed: () => _launchUrl(project.githubUrl!),
              icon: const Icon(Icons.code, size: 20),
              color: AppColors.textSecondary,
              tooltip: 'View Code',
            ),
          if (project.liveDemoUrl != null)
            IconButton(
              onPressed: () => _launchUrl(project.liveDemoUrl!),
              icon: const Icon(Icons.launch, size: 20),
              color: accentColor,
              tooltip: 'Live Demo',
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left panel - info
        Expanded(
          flex: 3,
          child: _buildInfoPanel()
              .animate()
              .fadeIn(duration: 500.ms)
              .slideX(begin: -0.05),
        ),
        const SizedBox(width: 32),
        // Right panel - features & actions
        Expanded(
          flex: 2,
          child: _buildSidePanel()
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .slideX(begin: 0.05),
        ),
      ],
    );
  }

  Widget _buildMobileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoPanel().animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 24),
        _buildSidePanel()
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildInfoPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title section
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Icon(
                Icons.apps,
                color: accentColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.subtitle,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        // Description
        const Text(
          AppStrings.overview,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          project.description,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        // Features
        const Text(
          AppStrings.features,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        FeatureListWidget(
          features: project.features,
          accentColor: accentColor,
        ),
      ],
    );
  }

  Widget _buildSidePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tech Stack
        const Text(
          AppStrings.techStack,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: project.techStack
              .map((tech) => TechChipWidget(label: tech, color: accentColor))
              .toList(),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        // Action buttons
        if (project.liveDemoUrl != null) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _launchUrl(project.liveDemoUrl!),
              icon: const Icon(Icons.rocket_launch, size: 18),
              label: const Text(AppStrings.launchDemo),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (project.githubUrl != null)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _launchUrl(project.githubUrl!),
              icon: const Icon(Icons.code, size: 18),
              label: const Text(AppStrings.viewCode),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.glassBorder),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
