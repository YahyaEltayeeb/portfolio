import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../models/skill_model.dart';

class SkillCategoryCard extends StatefulWidget {
  final String category;
  final List<SkillModel> skills;
  final IconData icon;

  const SkillCategoryCard({
    super.key,
    required this.category,
    required this.skills,
    required this.icon,
  });

  @override
  State<SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<SkillCategoryCard> {
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
                    color: AppColors.primaryCyan.withValues(alpha: 0.1),
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
            // Category Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCyan.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 20,
                    color: AppColors.primaryCyan,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.category,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.skills.map((skill) {
                return _SkillBadge(name: skill.name);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillBadge extends StatefulWidget {
  final String name;

  const _SkillBadge({required this.name});

  @override
  State<_SkillBadge> createState() => _SkillBadgeState();
}

class _SkillBadgeState extends State<_SkillBadge> {
  bool _badgeHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _badgeHovered = true),
      onExit: (_) => setState(() => _badgeHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _badgeHovered
              ? AppColors.primaryCyan.withValues(alpha: 0.2)
              : AppColors.background.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _badgeHovered
                ? AppColors.primaryCyan
                : AppColors.border.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
        child: Text(
          widget.name,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: _badgeHovered ? FontWeight.w600 : FontWeight.w500,
            color: _badgeHovered
                ? AppColors.primaryCyan
                : AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}
