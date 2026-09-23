import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/animations/transitions/visibility_fade_slide.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
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
            horizontal: isMobile ? 24 : 48,
            vertical: isMobile ? 40 : 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section Header
              Text(
                AppStrings.howIWorkTitle,
                style: GoogleFonts.poppins(
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
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 14 : 16,
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 56),

              // Responsive Timeline
              isMobile
                  ? _buildMobileVerticalTimeline(steps)
                  : _buildDesktopHorizontalTimeline(steps),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHorizontalTimeline(List<WorkflowStepModel> steps) {
    return Column(
      children: [
        // Connected Nodes Row with Connecting Lines
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Connecting line
                return Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryCyan.withValues(alpha: 0.6),
                          AppColors.glow.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final stepIndex = index ~/ 2;
              final step = steps[stepIndex];
              return _TimelineNode(
                stepNumber: step.stepNumber,
                icon: step.icon,
              );
            }),
          ),
        ),
        const SizedBox(height: 28),

        // 5 Step Cards Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: steps.map((step) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _StepCard(step: step),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMobileVerticalTimeline(List<WorkflowStepModel> steps) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vertical node + connector line
              Column(
                children: [
                  _TimelineNode(
                    stepNumber: step.stepNumber,
                    icon: step.icon,
                    size: 40,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: AppColors.primaryCyan.withValues(alpha: 0.3),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Step card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _StepCard(step: step),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final int stepNumber;
  final IconData icon;
  final double size;

  const _TimelineNode({
    required this.stepNumber,
    required this.icon,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.card,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryCyan, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCyan.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, size: size * 0.45, color: AppColors.primaryCyan),
      ),
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
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(20),
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
                    color: AppColors.primaryCyan.withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Number Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryCyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryCyan.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                '0${widget.step.stepNumber}',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryCyan,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Step Title
            Text(
              widget.step.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),

            // Step Description
            Text(
              widget.step.description,
              style: GoogleFonts.outfit(
                fontSize: 13,
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
