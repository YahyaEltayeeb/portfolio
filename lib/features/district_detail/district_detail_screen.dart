import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/district_model.dart';
import '../../responsive/responsive_layout.dart';
import '../project_detail/project_detail_screen.dart';
import 'widgets/project_card_widget.dart';

class DistrictDetailScreen extends StatelessWidget {
  final DistrictModel district;

  const DistrictDetailScreen({super.key, required this.district});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, isMobile),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 16 : 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDistrictInfo(isMobile)
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: -0.05),
                    const SizedBox(height: AppDimensions.spacingXl),
                    _buildProjectsList(context, isMobile),
                  ],
                ),
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
          const SizedBox(width: 8),
          Text(
            'City Map',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: isMobile ? 13 : 14,
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
          Text(
            district.name.replaceAll('\n', ' '),
            style: TextStyle(
              color: district.accentColor,
              fontSize: isMobile ? 13 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictInfo(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // District name
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: district.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Icon(
                district.icon,
                color: district.accentColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    district.name.replaceAll('\n', ' '),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${district.projectCount} Projects',
                    style: TextStyle(
                      color: district.accentColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Text(
          district.description,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        // Highlights
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: district.highlights.map((h) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: district.accentColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: district.accentColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                h,
                style: TextStyle(
                  color: district.accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProjectsList(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Projects in this District',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        ...district.projects.asMap().entries.map((entry) {
          final index = entry.key;
          final project = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ProjectCardWidget(
              project: project,
              accentColor: district.accentColor,
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ProjectDetailScreen(
                      project: project,
                      accentColor: district.accentColor,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            )
                .animate()
                .fadeIn(delay: (100 * index).ms, duration: 400.ms)
                .slideY(begin: 0.1),
          );
        }),
      ],
    );
  }
}
