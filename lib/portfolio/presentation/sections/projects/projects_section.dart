import 'package:flutter/material.dart';
import '../../../../core/animations/transitions/visibility_fade_slide.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../repositories/projects_repository.dart';
import 'project_grid_card.dart';

/// Redesigned Projects section featuring a compact, modern, animated responsive grid
/// (3 cards on desktop, 2 on tablet, 1 on mobile).
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final projects = const ProjectsRepository().getProjects();

    return VisibilityFadeSlide(
      visibilityKey: 'projects-section',
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Responsive.maxContentWidth,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 48,
            vertical: isMobile ? 48 : 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section Header
              Text(
                AppStrings.projectsTitle,
                style: AppTypography.heading(
                  fontSize: isMobile ? 26 : 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  AppStrings.projectsSubtitle,
                  style: AppTypography.body(
                    fontSize: isMobile ? 14 : 16,
                    color: AppColors.secondaryText,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isMobile ? 36 : 48),

              // Responsive Project Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final double availableWidth = constraints.maxWidth;
                  final int columnCount;
                  if (availableWidth >= 980) {
                    columnCount = 3; // Desktop: 3 cards per row
                  } else if (availableWidth >= 600) {
                    columnCount = 2; // Tablet: 2 cards per row
                  } else {
                    columnCount = 1; // Mobile: 1 card per row
                  }

                  final double spacing = isMobile ? 18.0 : 22.0;
                  final double runSpacing = isMobile ? 20.0 : 24.0;
                  final double cardWidth =
                      (availableWidth - ((columnCount - 1) * spacing)) /
                      columnCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: runSpacing,
                    children: [
                      for (int i = 0; i < projects.length; i++)
                        SizedBox(
                          width: cardWidth,
                          child: ProjectGridCard(
                            project: projects[i],
                            index: i,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
