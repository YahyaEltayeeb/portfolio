import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/animations/transitions/visibility_fade_slide.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive.dart';

class _ContactItem {
  final String title;
  final String valueText;
  final String? copyText;
  final String actionUrl;
  final FaIconData icon;
  final String actionTooltip;

  const _ContactItem({
    required this.title,
    required this.valueText,
    this.copyText,
    required this.actionUrl,
    required this.icon,
    required this.actionTooltip,
  });
}

/// Compact, modern Contact Section featuring:
/// - 4 sleek, compact cards (Email, WhatsApp/Phone, LinkedIn, GitHub)
/// - Clearly displayed email & phone number with technical monospace font
/// - Instant one-tap Copy to Clipboard button with visual confirmation
/// - Direct action launcher (mailto, wa.me, LinkedIn, GitHub)
/// - Fully responsive layout (4 cards on desktop, 2x2 on tablet, vertical list on mobile)
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  List<_ContactItem> get _items => const [
    _ContactItem(
      title: 'Email',
      valueText: AppStrings.email,
      copyText: AppStrings.email,
      actionUrl: AppLinks.email,
      icon: FontAwesomeIcons.envelope,
      actionTooltip: 'Send Email',
    ),
    _ContactItem(
      title: 'Phone & WhatsApp',
      valueText: AppStrings.phone,
      copyText: '+201289078927',
      actionUrl: AppLinks.whatsApp,
      icon: FontAwesomeIcons.whatsapp,
      actionTooltip: 'Chat on WhatsApp',
    ),
    _ContactItem(
      title: 'LinkedIn',
      valueText: AppStrings.linkedInHandle,
      actionUrl: AppLinks.linkedIn,
      icon: FontAwesomeIcons.linkedinIn,
      actionTooltip: 'View LinkedIn Profile',
    ),
    _ContactItem(
      title: 'GitHub',
      valueText: AppStrings.gitHubHandle,
      actionUrl: AppLinks.gitHub,
      icon: FontAwesomeIcons.github,
      actionTooltip: 'View GitHub Repositories',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final items = _items;

    return VisibilityFadeSlide(
      visibilityKey: 'contact-section',
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
                AppStrings.contactTitle,
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
                  AppStrings.contactSubtitle,
                  style: AppTypography.body(
                    fontSize: isMobile ? 14 : 16,
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isMobile ? 36 : 48),

              // 4 Compact Cards Responsive Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final double width = constraints.maxWidth;
                  if (width >= 980) {
                    // Desktop: Single row of 4 compact cards
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < items.length; i++) ...[
                          if (i > 0) const SizedBox(width: 14),
                          Expanded(child: _ContactCard(item: items[i])),
                        ],
                      ],
                    );
                  } else if (width >= 600) {
                    // Tablet: 2x2 Grid
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _ContactCard(item: items[0])),
                            const SizedBox(width: 14),
                            Expanded(child: _ContactCard(item: items[1])),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: _ContactCard(item: items[2])),
                            const SizedBox(width: 14),
                            Expanded(child: _ContactCard(item: items[3])),
                          ],
                        ),
                      ],
                    );
                  } else {
                    // Mobile: Vertical list of compact cards
                    return Column(
                      children: [
                        for (int i = 0; i < items.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          _ContactCard(item: items[i]),
                        ],
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  final _ContactItem item;

  const _ContactCard({required this.item});

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => AppLinks.openUrl(widget.item.actionUrl),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 18,
            vertical: isMobile ? 16 : 18,
          ),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.cardHover : AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primaryCyan.withValues(alpha: 0.6)
                  : AppColors.border,
              width: _isHovered ? 1.5 : 1.0,
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
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Icon on left, Quick Action buttons on right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? AppColors.primaryCyan.withValues(alpha: 0.2)
                          : AppColors.primaryCyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryCyan.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        widget.item.icon,
                        size: 17,
                        color: AppColors.primaryCyan,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.item.copyText != null) ...[
                        _CopyIconButton(textToCopy: widget.item.copyText!),
                        const SizedBox(width: 6),
                      ],
                      _LaunchIconButton(
                        url: widget.item.actionUrl,
                        tooltip: widget.item.actionTooltip,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Title
              Text(
                widget.item.title,
                style: AppTypography.heading(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),

              // Value text
              Text(
                widget.item.valueText,
                style: widget.item.copyText != null
                    ? AppTypography.mono(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      )
                    : AppTypography.heading(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CopyIconButton extends StatefulWidget {
  final String textToCopy;

  const _CopyIconButton({required this.textToCopy});

  @override
  State<_CopyIconButton> createState() => _CopyIconButtonState();
}

class _CopyIconButtonState extends State<_CopyIconButton> {
  bool _copied = false;
  bool _hovered = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: widget.textToCopy));
    if (!mounted) return;
    setState(() => _copied = true);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied "${widget.textToCopy}" to clipboard!',
          style: AppTypography.body(fontSize: 13, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF132238),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.primaryCyan, width: 1),
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _copied ? 'Copied!' : 'Copy to clipboard',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _handleCopy,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _copied
                  ? AppColors.success.withValues(alpha: 0.2)
                  : (_hovered
                        ? AppColors.primaryCyan.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.04)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _copied
                    ? AppColors.success
                    : (_hovered ? AppColors.primaryCyan : AppColors.border),
                width: 1,
              ),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _copied
                    ? const Icon(
                        Icons.check_rounded,
                        key: ValueKey('check'),
                        size: 16,
                        color: AppColors.success,
                      )
                    : Icon(
                        Icons.copy_rounded,
                        key: const ValueKey('copy'),
                        size: 15,
                        color: _hovered
                            ? AppColors.primaryCyan
                            : AppColors.secondaryText,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LaunchIconButton extends StatefulWidget {
  final String url;
  final String tooltip;

  const _LaunchIconButton({required this.url, required this.tooltip});

  @override
  State<_LaunchIconButton> createState() => _LaunchIconButtonState();
}

class _LaunchIconButtonState extends State<_LaunchIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => AppLinks.openUrl(widget.url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.primaryCyan.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _hovered ? AppColors.primaryCyan : AppColors.border,
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.arrow_outward_rounded,
                size: 15,
                color: _hovered
                    ? AppColors.primaryCyan
                    : AppColors.secondaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
