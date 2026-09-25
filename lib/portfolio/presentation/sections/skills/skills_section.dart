import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/animations/transitions/visibility_fade_slide.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive.dart';

/// Direction of continuous horizontal marquee motion.
enum MarqueeDirection {
  /// Moves from right to left (Row 1).
  rightToLeft,

  /// Moves from left to right (Row 2).
  leftToRight,
}

/// Data definition for an individual skill marquee item.
class SkillMarqueeItem {
  final String name;
  final IconData? icon;
  final FaIconData? faIcon;

  const SkillMarqueeItem({required this.name, this.icon, this.faIcon})
    : assert(icon != null || faIcon != null);
}

/// Redesigned Skills Section with two continuously moving horizontal marquee rows.
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  /// Row 1 — Core Development Skills
  static const List<SkillMarqueeItem> row1Skills = [
    SkillMarqueeItem(name: 'Flutter', icon: Icons.flutter_dash),
    SkillMarqueeItem(name: 'Dart', icon: Icons.code_rounded),
    SkillMarqueeItem(name: 'Clean Architecture', icon: Icons.layers_outlined),
    SkillMarqueeItem(name: 'BLoC', icon: Icons.alt_route_rounded),
    SkillMarqueeItem(name: 'Cubit', icon: Icons.tune_rounded),
    SkillMarqueeItem(name: 'Dependency Injection', icon: Icons.hub_outlined),
    SkillMarqueeItem(name: 'RESTful APIs', icon: Icons.cloud_sync_outlined),
    SkillMarqueeItem(name: 'SOLID Principles', icon: Icons.verified_outlined),
  ];

  /// Row 2 — Production & Tools Skills
  static const List<SkillMarqueeItem> row2Skills = [
    SkillMarqueeItem(
      name: 'Firebase',
      icon: Icons.local_fire_department_rounded,
    ),
    SkillMarqueeItem(
      name: 'OneSignal',
      icon: Icons.notifications_active_outlined,
    ),
    SkillMarqueeItem(name: 'Google Maps', icon: Icons.map_outlined),
    SkillMarqueeItem(name: 'Real-time Tracking', icon: Icons.near_me_outlined),
    SkillMarqueeItem(
      name: 'Background Location',
      icon: Icons.my_location_rounded,
    ),
    SkillMarqueeItem(name: 'Payment Integration', icon: Icons.payment_rounded),
    SkillMarqueeItem(name: 'Unit Testing', icon: Icons.fact_check_outlined),
    SkillMarqueeItem(name: 'Widget Testing', icon: Icons.widgets_outlined),
    SkillMarqueeItem(name: 'Git & GitHub', faIcon: FontAwesomeIcons.github),
    SkillMarqueeItem(name: 'Agile / Scrum', icon: Icons.groups_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return VisibilityFadeSlide(
      visibilityKey: 'skills-section',
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
                AppStrings.skillsTitle,
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
                  AppStrings.skillsSubtitle,
                  style: AppTypography.body(
                    fontSize: isMobile ? 14 : 16,
                    color: AppColors.secondaryText,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isMobile ? 32 : 44),

              // Marquee Rows or Accessible Reduced-Motion Static Fallback
              if (disableAnimations)
                _buildStaticWrap(isMobile)
              else
                _buildMarqueeRows(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarqueeRows(bool isMobile) {
    return Column(
      children: [
        // Row 1: Core Development (Right to Left)
        InfiniteMarqueeRow(
          key: const ValueKey('skills_row_1_core'),
          skills: row1Skills,
          direction: MarqueeDirection.rightToLeft,
          speed: 38.0,
          isMobile: isMobile,
        ),
        SizedBox(height: isMobile ? 14 : 20),
        // Row 2: Production & Tools (Left to Right)
        InfiniteMarqueeRow(
          key: const ValueKey('skills_row_2_tools'),
          skills: row2Skills,
          direction: MarqueeDirection.leftToRight,
          speed: 38.0,
          isMobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildStaticWrap(bool isMobile) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: isMobile ? 8 : 12,
          runSpacing: isMobile ? 8 : 12,
          children: [
            for (final skill in row1Skills)
              SkillGlassChip(skill: skill, isMobile: isMobile),
          ],
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: isMobile ? 8 : 12,
          runSpacing: isMobile ? 8 : 12,
          children: [
            for (final skill in row2Skills)
              SkillGlassChip(skill: skill, isMobile: isMobile),
          ],
        ),
      ],
    );
  }
}

/// A single continuously moving marquee row with seamless duplication, scoped controller,
/// edge-fade gradient masks, and interactive pause on hover / touch press-and-hold.
class InfiniteMarqueeRow extends StatefulWidget {
  final List<SkillMarqueeItem> skills;
  final MarqueeDirection direction;
  final double speed;
  final bool isMobile;

  const InfiniteMarqueeRow({
    super.key,
    required this.skills,
    required this.direction,
    this.speed = 38.0,
    required this.isMobile,
  });

  @override
  State<InfiniteMarqueeRow> createState() => InfiniteMarqueeRowState();
}

class InfiniteMarqueeRowState extends State<InfiniteMarqueeRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _singleCycleWidth = 0.0;
  final GlobalKey _measureKey = GlobalKey();

  bool _isHovered = false;
  bool _isPressed = false;

  Widget? _cachedStrip;

  /// Expose direction for testing
  MarqueeDirection get direction => widget.direction;

  /// Expose pause state for testing
  bool get isPaused => !_controller.isAnimating;

  /// Expose current offset for testing
  double get currentOffset => _calculateOffset(_controller.value);

  /// Expose controller for testing
  AnimationController get controller => _controller;

  @override
  void initState() {
    super.initState();
    // Default estimated duration until exact measurement on frame 1
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 35),
    );
    _controller.repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureAndSchedule();
    });
  }

  @override
  void didUpdateWidget(covariant InfiniteMarqueeRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMobile != widget.isMobile ||
        oldWidget.skills != widget.skills ||
        oldWidget.speed != widget.speed) {
      _cachedStrip = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _measureAndSchedule();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _measureAndSchedule() {
    if (!mounted) return;
    final renderBox =
        _measureKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize && renderBox.size.width > 0) {
      final measuredWidth = renderBox.size.width;
      if ((_singleCycleWidth - measuredWidth).abs() > 1.0) {
        setState(() {
          _singleCycleWidth = measuredWidth;
        });

        final durationMs = ((measuredWidth / widget.speed) * 1000).round();
        _controller.duration = Duration(milliseconds: durationMs);

        if (!_isHovered && !_isPressed && !_controller.isAnimating) {
          _controller.repeat();
        }
      }
    }
  }

  void _onPointerEnter() {
    _isHovered = true;
    _syncAnimationState();
  }

  void _onPointerExit() {
    _isHovered = false;
    _syncAnimationState();
  }

  void _onTouchStart() {
    _isPressed = true;
    _syncAnimationState();
  }

  void _onTouchEnd() {
    _isPressed = false;
    _syncAnimationState();
  }

  void _syncAnimationState() {
    final shouldPause = _isHovered || _isPressed;
    if (shouldPause) {
      if (_controller.isAnimating) {
        _controller.stop(canceled: false);
      }
    } else {
      if (!_controller.isAnimating && mounted) {
        _controller.repeat();
      }
    }
  }

  double _calculateOffset(double value) {
    final cycleW = _singleCycleWidth > 0 ? _singleCycleWidth : 1200.0;
    if (widget.direction == MarqueeDirection.rightToLeft) {
      // Moves leftwards: 0 to -W
      return -value * cycleW;
    } else {
      // Moves rightwards: -W to 0
      return -cycleW + (value * cycleW);
    }
  }

  Widget _buildSingleCycle({Key? key, required bool isMobile}) {
    final double gap = isMobile ? 12.0 : 16.0;
    return Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final skill in widget.skills) ...[
          SkillGlassChip(skill: skill, isMobile: isMobile),
          SizedBox(width: gap),
        ],
      ],
    );
  }

  Widget _getOrBuildStrip(bool isMobile) {
    if (_cachedStrip != null) return _cachedStrip!;

    // 4 identical cycles guarantee seamless loop coverage across all viewports
    _cachedStrip = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSingleCycle(key: _measureKey, isMobile: isMobile),
        _buildSingleCycle(isMobile: isMobile),
        _buildSingleCycle(isMobile: isMobile),
        _buildSingleCycle(isMobile: isMobile),
      ],
    );
    return _cachedStrip!;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;
    final rowHeight = isMobile ? 48.0 : 56.0;

    return MouseRegion(
      onEnter: (_) => _onPointerEnter(),
      onExit: (_) => _onPointerExit(),
      child: GestureDetector(
        onLongPressStart: (_) => _onTouchStart(),
        onLongPressEnd: (_) => _onTouchEnd(),
        onLongPressCancel: () => _onTouchEnd(),
        onHorizontalDragDown: (_) => _onTouchStart(),
        onHorizontalDragEnd: (_) => _onTouchEnd(),
        onHorizontalDragCancel: () => _onTouchEnd(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Subtle edge fade gradient mask on left and right borders
            return ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.04, 0.96, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: RepaintBoundary(
                child: ClipRect(
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: rowHeight,
                    child: OverflowBox(
                      alignment: Alignment.centerLeft,
                      minWidth: 0,
                      maxWidth: double.infinity,
                      minHeight: rowHeight,
                      maxHeight: rowHeight,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final offset = _calculateOffset(_controller.value);
                          return Transform.translate(
                            offset: Offset(offset, 0),
                            child: child,
                          );
                        },
                        child: _getOrBuildStrip(isMobile),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Compact premium glass chip displaying an individual skill with its minimal icon.
class SkillGlassChip extends StatefulWidget {
  final SkillMarqueeItem skill;
  final bool isMobile;

  const SkillGlassChip({
    super.key,
    required this.skill,
    required this.isMobile,
  });

  @override
  State<SkillGlassChip> createState() => _SkillGlassChipState();
}

class _SkillGlassChipState extends State<SkillGlassChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14 : 18,
          vertical: isMobile ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.cardHover.withValues(alpha: 0.95)
              : AppColors.card.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered
                ? AppColors.primaryCyan.withValues(alpha: 0.8)
                : AppColors.border.withValues(alpha: 0.85),
            width: 1.2,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.glow.withValues(alpha: 0.25),
                blurRadius: 14,
                spreadRadius: 1,
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.skill.faIcon != null)
              FaIcon(
                widget.skill.faIcon,
                size: isMobile ? 14 : 16,
                color: _isHovered
                    ? AppColors.primaryCyan
                    : AppColors.primaryCyan.withValues(alpha: 0.95),
              )
            else
              Icon(
                widget.skill.icon,
                size: isMobile ? 15 : 18,
                color: _isHovered
                    ? AppColors.primaryCyan
                    : AppColors.primaryCyan.withValues(alpha: 0.95),
              ),
            SizedBox(width: isMobile ? 8 : 10),
            Text(
              widget.skill.name,
              style: AppTypography.mono(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
