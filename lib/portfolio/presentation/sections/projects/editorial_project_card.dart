import 'package:flutter/material.dart';
import '../../../../core/animations/routes/fade_route.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/spacing.dart';
import '../../../models/project_model.dart';
import '../../screens/project_details_screen.dart';
import '../../widgets/portfolio_image.dart';
import '../../widgets/smart_project_button.dart';

/// Large editorial project card featuring uncropped cover.png, max 3 tech tags,
/// production status badge, internal details navigation, and smart external button.
class EditorialProjectCard extends StatefulWidget {
  final ProjectModel project;
  final bool isImageLeft;

  const EditorialProjectCard({
    super.key,
    required this.project,
    this.isImageLeft = true,
  });

  @override
  State<EditorialProjectCard> createState() => _EditorialProjectCardState();
}

class _EditorialProjectCardState extends State<EditorialProjectCard> {
  bool _isHovered = false;

  void _openDetails(BuildContext context) {
    Navigator.of(
      context,
    ).push(FadeRoute(page: ProjectDetailsScreen(project: widget.project)));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final primaryAction = widget.project.primaryExternalAction;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.cardHover : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppColors.primaryCyan : AppColors.border,
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primaryCyan.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: isMobile
              ? _buildMobileLayout(context, primaryAction)
              : _buildDesktopLayout(context, primaryAction),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    ProjectAction? primaryAction,
  ) {
    final imageWidget = Expanded(
      flex: 52,
      child: _buildCoverContainer(context),
    );

    final infoWidget = Expanded(
      flex: 48,
      child: Padding(
        padding: EdgeInsets.only(
          left: widget.isImageLeft ? 32 : 0,
          right: widget.isImageLeft ? 0 : 32,
        ),
        child: _buildInfoColumn(context, primaryAction),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.isImageLeft
          ? [imageWidget, infoWidget]
          : [infoWidget, imageWidget],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    ProjectAction? primaryAction,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCoverContainer(context),
        verticalSpace(16),
        _buildInfoColumn(context, primaryAction),
      ],
    );
  }

  Widget _buildCoverContainer(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetails(context),
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PortfolioImage(
              assetPath: widget.project.coverAsset,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, ProjectAction? primaryAction) {
    // Maximum 3 important technology tags
    final tags = widget.project.techStack.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Title & Live App Badge
        Row(
          children: [
            Expanded(
              child: Text(
                widget.project.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            if (widget.project.isProduction) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success),
                ),
                child: const Text(
                  AppStrings.liveAppBadge,
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        verticalSpace(10),

        // Short Description
        Text(
          widget.project.shortDescription,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.secondaryText,
            height: 1.5,
          ),
        ),
        verticalSpace(16),

        // Max 3 Technology tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tech) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cardHover.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                tech,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryCyan,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
        verticalSpace(22),

        // Action Buttons Row: "View Project" + Smart Primary External Action
        Wrap(
          spacing: 12,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // "View Project" Button (always opens internal details)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _openDetails(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCyan,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.viewProject,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.background,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: AppColors.background,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Smart External Action Button (priority fallback, hidden if null)
            if (primaryAction != null)
              SmartProjectButton(action: primaryAction),
          ],
        ),
      ],
    );
  }
}
