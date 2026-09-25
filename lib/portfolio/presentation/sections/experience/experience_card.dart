import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../models/experience_model.dart';

class ExperienceCard extends StatefulWidget {
  final ExperienceModel experience;
  final bool isLast;

  const ExperienceCard({
    super.key,
    required this.experience,
    required this.isLast,
  });

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Available width for the inner card is row width minus timeline node (18px) and gap (24px)
        final double cardAvailableWidth = constraints.maxWidth - 42.0;
        final bool isNarrow = cardAvailableWidth < 560;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Connecting line
            if (!widget.isLast)
              Positioned(
                left: 8,
                top: 22,
                bottom: 0,
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryCyan.withValues(alpha: 0.6),
                        AppColors.primaryCyan.withValues(alpha: 0.15),
                      ],
                    ),
                  ),
                ),
              ),

            // Circle node
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryCyan, width: 3.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryCyan.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),

            // Experience Card Details
            Padding(
              padding: const EdgeInsets.only(left: 42, bottom: 36),
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.all(isNarrow ? 18 : 24),
                  decoration: BoxDecoration(
                    color: _isHovered ? AppColors.cardHover : AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isHovered
                          ? AppColors.primaryCyan.withValues(alpha: 0.6)
                          : AppColors.border,
                      width: _isHovered ? 1.5 : 1,
                    ),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: AppColors.primaryCyan.withValues(
                                alpha: 0.1,
                              ),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header: Narrow layout (< 560px) vs Desktop layout (>= 560px)
                      if (isNarrow) ...[
                        // 1. Date first as simple uppercase text without badge/container
                        Text(
                          widget.experience.period.toUpperCase(),
                          style: AppTypography.mono(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8,
                            color: AppColors.primaryCyan.withValues(
                              alpha: 0.85,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 2. Job Title below date across full width
                        Text(
                          widget.experience.title,
                          style: AppTypography.heading(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                            height: 1.25,
                          ),
                          softWrap: true,
                        ),
                        const SizedBox(height: 6),

                        // 3. Company below job title
                        Text(
                          widget.experience.company,
                          style: AppTypography.heading(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryCyan,
                            height: 1.3,
                          ),
                          softWrap: true,
                        ),
                      ] else ...[
                        // Desktop header: Title & Company on left, Period badge on right
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.experience.title,
                                    style: AppTypography.heading(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.experience.company,
                                    style: AppTypography.heading(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryCyan,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Period Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryCyan.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primaryCyan.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                widget.experience.period,
                                style: AppTypography.mono(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryCyan,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Responsibilities Bullets
                      ...widget.experience.responsibilities.map((bullet) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 7),
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryCyan,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  bullet,
                                  style: AppTypography.body(
                                    fontSize: 14,
                                    color: AppColors.secondaryText,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),

                      // Technologies Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.experience.technologies.map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background.withValues(
                                alpha: 0.6,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              tech,
                              style: AppTypography.mono(
                                fontSize: 11.5,
                                color: AppColors.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
