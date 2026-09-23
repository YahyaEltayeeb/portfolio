import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../models/project_model.dart';

/// Renders the single highest-priority external action button for a project card,
/// or a list of action buttons for the details page.
///
/// Priority: App Store → Play Store → GitHub → Live Demo.
/// Completely hidden when no valid URL exists.
class SmartProjectButton extends StatefulWidget {
  final ProjectAction action;
  final bool isPrimary;

  const SmartProjectButton({
    super.key,
    required this.action,
    this.isPrimary = false,
  });

  @override
  State<SmartProjectButton> createState() => _SmartProjectButtonState();
}

class _SmartProjectButtonState extends State<SmartProjectButton> {
  bool _isHovered = false;

  Future<void> _launch() async {
    final uri = Uri.tryParse(widget.action.url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isPrimary
        ? AppColors.primaryCyan
        : AppColors.secondaryText;
    final borderColor = _isHovered ? AppColors.primaryCyan : AppColors.border;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.primaryCyan.withValues(alpha: 0.12)
                : AppColors.cardHover.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primaryCyan.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.action.icon,
                size: 14,
                color: _isHovered ? AppColors.primaryCyan : primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                widget.action.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _isHovered ? AppColors.primaryText : primaryColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_outward_rounded,
                size: 13,
                color: _isHovered
                    ? AppColors.primaryCyan
                    : AppColors.secondaryText.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
