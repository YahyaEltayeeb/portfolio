import 'package:flutter/material.dart';
import '../../../../core/animations/transitions/visibility_fade_slide.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../models/workflow_step_model.dart';
import '../../../repositories/workflow_repository.dart';

class HowIWorkSection extends StatelessWidget {
  const HowIWorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final steps = const WorkflowRepository().getSteps();

    return VisibilityFadeSlide(
      visibilityKey: 'how-i-work-section',
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 48,
            vertical: isMobile ? 40 : 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section Header
              Text(
                AppStrings.howIWorkTitle,
                style: AppTypography.heading(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  AppStrings.howIWorkSubtitle,
                  style: AppTypography.body(
                    fontSize: isMobile ? 14 : 16,
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isMobile ? 36 : 56),

              // Responsive Process Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final double width = constraints.maxWidth;
                  if (width >= 960) {
                    // Desktop: 5 connected cards in a single row with equal heights
                    return _buildDesktopLayout(steps);
                  } else if (width >= 620) {
                    // Tablet: 3 cards on top row, 2 cards on bottom row
                    return _buildTabletLayout(steps);
                  } else {
                    // Mobile: Vertical list of step cards
                    return _buildMobileLayout(steps);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Desktop layout: 5 equal-height cards connected with an elegant horizontal progress bar.
  Widget _buildDesktopLayout(List<WorkflowStepModel> steps) {
    return Column(
      children: [
        // Sleek horizontal progress line with numbered checkpoints
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Connecting gradient line
                return Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryCyan.withValues(alpha: 0.7),
                          AppColors.primaryCyan.withValues(alpha: 0.25),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final stepIndex = index ~/ 2;
              final stepNumber = steps[stepIndex].stepNumber;
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0B192C),
                  border: Border.all(
                    color: AppColors.primaryCyan,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryCyan.withValues(alpha: 0.35),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '0$stepNumber',
                    style: AppTypography.mono(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryCyan,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),

        // 5 cards sharing uniform equal height
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                if (i > 0) const SizedBox(width: 14),
                Expanded(
                  child: _StepCard(step: steps[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Tablet layout: 3 cards on top row, 2 cards on bottom row with equal heights per row.
  Widget _buildTabletLayout(List<WorkflowStepModel> steps) {
    return Column(
      children: [
        // Row 1: Steps 1, 2, 3
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: 14),
                Expanded(
                  child: _StepCard(step: steps[i]),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Row 2: Steps 4, 5
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _StepCard(step: steps[3])),
              const SizedBox(width: 14),
              Expanded(child: _StepCard(step: steps[4])),
            ],
          ),
        ),
      ],
    );
  }

  /// Mobile layout: Vertical clean list of step cards.
  Widget _buildMobileLayout(List<WorkflowStepModel> steps) {
    return Column(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _StepCard(step: steps[i]),
        ],
      ],
    );
  }
}

class _StepCard extends StatefulWidget {
  final WorkflowStepModel step;

  const _StepCard({required this.step});

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(
          0.0,
          _isHovered ? -4.0 : 0.0,
          0.0,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.cardHover.withValues(alpha: 0.95)
              : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColors.primaryCyan.withValues(alpha: 0.7)
                : AppColors.border,
            width: _isHovered ? 1.3 : 1.0,
          ),
          boxShadow: [
            if (_isHovered) ...[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.primaryCyan.withValues(alpha: 0.15),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ] else ...[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Glowing Icon + Step Number Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? AppColors.primaryCyan.withValues(alpha: 0.2)
                        : AppColors.primaryCyan.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: _isHovered
                          ? AppColors.primaryCyan
                          : AppColors.primaryCyan.withValues(alpha: 0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      widget.step.icon,
                      size: 20,
                      color: AppColors.primaryCyan,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? AppColors.primaryCyan.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isHovered
                          ? AppColors.primaryCyan.withValues(alpha: 0.5)
                          : AppColors.border,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    '0${widget.step.stepNumber}',
                    style: AppTypography.mono(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: _isHovered
                          ? AppColors.primaryCyan
                          : AppColors.secondaryText,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Step Title with consistent height so descriptions align horizontally
            SizedBox(
              height: 44,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.step.title,
                  style: AppTypography.heading(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: _isHovered
                        ? AppColors.primaryCyan
                        : AppColors.primaryText,
                    height: 1.25,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Step Description
            Text(
              widget.step.description,
              style: AppTypography.body(
                fontSize: 13.0,
                color: AppColors.secondaryText,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
