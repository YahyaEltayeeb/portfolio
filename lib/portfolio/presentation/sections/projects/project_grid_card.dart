import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/animations/routes/fade_route.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../models/project_model.dart';
import '../../screens/project_details_screen.dart';
import '../../widgets/portfolio_image.dart';

/// Compact, modern, animated project card for Yahya Mohamed's portfolio grid.
///
/// Contains ONLY:
/// 1. Project cover (16:9 uncropped, BoxFit.contain, dark background)
/// 2. Small status badge ("Live App" or "GitHub")
/// 3. Project name
/// 4. Short project type subtitle
/// 5. "View Project" button with animated arrow
/// 6. Small external action icon button for App Store or GitHub when valid URL exists
class ProjectGridCard extends StatefulWidget {
  final ProjectModel project;
  final int index;

  const ProjectGridCard({super.key, required this.project, this.index = 0});

  @override
  State<ProjectGridCard> createState() => _ProjectGridCardState();
}

class _ProjectGridCardState extends State<ProjectGridCard>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _hoverController;
  late final Animation<double> _entranceFade;
  late final Animation<Offset> _entranceSlide;
  late final Animation<double> _hoverAnimation;

  bool _isHovered = false;
  bool _isPressed = false;
  double _tiltX = 0.0;
  double _tiltY = 0.0;

  @override
  void initState() {
    super.initState();

    // Section entrance animation with subtle stagger based on index
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    final double start = (widget.index * 0.1).clamp(0.0, 0.5);

    _entranceFade = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, 1.0, curve: Curves.easeOut),
    );

    _entranceSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // Desktop hover animation
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _hoverAnimation = CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _openDetails(BuildContext context) {
    Navigator.of(
      context,
    ).push(FadeRoute(page: ProjectDetailsScreen(project: widget.project)));
  }

  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _getProjectType(String title) {
    switch (title.toLowerCase()) {
      case 'zadna groceries':
        return 'Grocery Delivery Application';
      case 'zadna delivery':
        return 'Driver Delivery Application';
      case 'super fitness':
        return 'Fitness & Smart Coaching Application';
      case 'flowery e-commerce':
        return 'Flower Shopping Application';
      case 'flowery tracking':
        return 'Delivery Tracking Application';
      case 'exam app':
        return 'Quiz & Examination Application';
      default:
        return 'Mobile Application';
    }
  }

  void _onPointerMove(PointerEvent event, BoxConstraints constraints) {
    if (Responsive.isMobile(context)) return;
    final halfW = constraints.maxWidth / 2;
    final halfH = 340 / 2;
    final dx = (event.localPosition.dx - halfW) / halfW;
    final dy = (event.localPosition.dy - halfH) / halfH;
    setState(() {
      _tiltX = (-dy * 0.035).clamp(-0.04, 0.04);
      _tiltY = (dx * 0.035).clamp(-0.04, 0.04);
    });
  }

  void _onPointerExit() {
    setState(() {
      _isHovered = false;
      _tiltX = 0.0;
      _tiltY = 0.0;
    });
    _hoverController.reverse();
  }

  void _onPointerEnter() {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final primaryAction = widget.project.primaryExternalAction;

    if (disableAnimations) {
      _entranceController.value = 1.0;
    }

    return RepaintBoundary(
      child: SlideTransition(
        position: _entranceSlide,
        child: FadeTransition(
          opacity: _entranceFade,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return MouseRegion(
                onEnter: (_) => _onPointerEnter(),
                onExit: (_) => _onPointerExit(),
                onHover: (event) => _onPointerMove(event, constraints),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (_) {
                    if (isMobile) setState(() => _isPressed = true);
                  },
                  onTapUp: (_) {
                    if (isMobile) setState(() => _isPressed = false);
                  },
                  onTapCancel: () {
                    if (isMobile) setState(() => _isPressed = false);
                  },
                  onTap: () => _openDetails(context),
                  child: AnimatedBuilder(
                    animation: _hoverAnimation,
                    builder: (context, child) {
                      final hoverVal = _hoverAnimation.value;
                      final double translateY = isMobile
                          ? 0.0
                          : (-8.0 * hoverVal);
                      final double pressScale = _isPressed ? 0.98 : 1.0;

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..translateByDouble(0.0, translateY, 0.0, 1.0)
                          ..scaleByDouble(pressScale, pressScale, 1.0, 1.0)
                          ..rotateX(
                            isMobile || disableAnimations ? 0.0 : _tiltX,
                          )
                          ..rotateY(
                            isMobile || disableAnimations ? 0.0 : _tiltY,
                          ),
                        child: child,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? AppColors.cardHover.withValues(alpha: 0.95)
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isHovered
                              ? AppColors.primaryCyan.withValues(alpha: 0.8)
                              : AppColors.border,
                          width: _isHovered ? 1.4 : 1.0,
                        ),
                        boxShadow: [
                          if (_isHovered) ...[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.45),
                              blurRadius: 26,
                              offset: const Offset(0, 14),
                            ),
                            BoxShadow(
                              color: AppColors.primaryCyan.withValues(
                                alpha: 0.18,
                              ),
                              blurRadius: 22,
                              spreadRadius: 1,
                            ),
                          ] else ...[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 1. Cover visual area (16:9, contain, dark bg, clipped to top corners)
                          _buildCoverArea(isMobile),

                          // 2. Card Content Area
                          Padding(
                            padding: EdgeInsets.all(isMobile ? 16.0 : 18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header row: Project type on left + Live App Badge on right (only when live)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _getProjectType(widget.project.title),
                                        style: AppTypography.mono(
                                          fontSize: isMobile ? 11.5 : 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryCyan,
                                          letterSpacing: 0.3,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (widget.project.isProduction) ...[
                                      const SizedBox(width: 8),
                                      _buildStatusBadge(),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Project name (fixed vertical height so cards remain equal height)
                                SizedBox(
                                  height: 48,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.project.title,
                                      style: AppTypography.heading(
                                        fontSize: isMobile ? 17.0 : 19.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryText,
                                        letterSpacing: -0.3,
                                        height: 1.25,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Action Row: "View Project" button & External Icon
                                _buildActionRow(
                                  context,
                                  primaryAction,
                                  isMobile,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCoverArea(bool isMobile) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: const Color(0xFF08121E),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Cover image centered and uncropped
              Center(
                child: AnimatedBuilder(
                  animation: _hoverAnimation,
                  builder: (context, child) {
                    final double scale = isMobile
                        ? 1.0
                        : (1.0 + (0.035 * _hoverAnimation.value));
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: PortfolioImage(
                    assetPath: widget.project.coverAsset,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
              ),

              // Soft one-time shine sweep on desktop hover
              if (!isMobile)
                AnimatedBuilder(
                  animation: _hoverAnimation,
                  builder: (context, _) {
                    final double progress = _hoverAnimation.value;
                    if (progress <= 0.01) return const SizedBox.shrink();

                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-2.0 + (3.5 * progress), -1.0),
                          end: Alignment(-1.0 + (3.5 * progress), 1.0),
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.14),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    );
                  },
                ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final bool isLive = widget.project.isProduction;
    if (!isLive) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF102820).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.8),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 12,
            color: AppColors.success,
          ),
          const SizedBox(width: 5),
          Text(
            'Live App',
            style: AppTypography.mono(
              color: AppColors.success,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    BuildContext context,
    ProjectAction? primaryAction,
    bool isMobile,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // "View Project" Button
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AnimatedBuilder(
              animation: _hoverAnimation,
              builder: (context, child) {
                final double arrowShift = isMobile
                    ? 0.0
                    : (4.0 * _hoverAnimation.value);

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _openDetails(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? AppColors.primaryCyan.withValues(alpha: 0.16)
                          : AppColors.cardHover.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isHovered
                            ? AppColors.primaryCyan.withValues(alpha: 0.7)
                            : AppColors.border,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Project',
                          style: AppTypography.heading(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: _isHovered
                                ? AppColors.primaryCyan
                                : AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Transform.translate(
                          offset: Offset(arrowShift, 0),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: _isHovered
                                ? AppColors.primaryCyan
                                : AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // External Action Button (App Store / GitHub)
        if (primaryAction != null && primaryAction.url.isNotEmpty) ...[
          const SizedBox(width: 8),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: _ExternalActionIconButton(
                action: primaryAction,
                onLaunch: () => _launchExternalUrl(primaryAction.url),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// External action button (App Store / GitHub) with label and outward diagonal arrow.
class _ExternalActionIconButton extends StatefulWidget {
  final ProjectAction action;
  final VoidCallback onLaunch;

  const _ExternalActionIconButton({
    required this.action,
    required this.onLaunch,
  });

  @override
  State<_ExternalActionIconButton> createState() =>
      _ExternalActionIconButtonState();
}

class _ExternalActionIconButtonState extends State<_ExternalActionIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Open in ${widget.action.label}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onLaunch,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.primaryCyan.withValues(alpha: 0.16)
                  : AppColors.cardHover.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered
                    ? AppColors.primaryCyan.withValues(alpha: 0.7)
                    : AppColors.border,
                width: 1.0,
              ),
              boxShadow: [
                if (_isHovered)
                  BoxShadow(
                    color: AppColors.primaryCyan.withValues(alpha: 0.25),
                    blurRadius: 10,
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.action.label,
                  style: AppTypography.heading(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: _isHovered
                        ? AppColors.primaryCyan
                        : AppColors.primaryText,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 200),
                  offset: _isHovered
                      ? const Offset(0.12, -0.12)
                      : Offset.zero,
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    size: 14,
                    color: _isHovered
                        ? AppColors.primaryCyan
                        : AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
