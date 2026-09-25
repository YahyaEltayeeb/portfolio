import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/animations/background/subtle_ambient_background.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/spacing.dart';
import '../../models/project_model.dart';
import '../widgets/full_screen_image_viewer.dart';
import '../widgets/portfolio_image.dart';
import '../widgets/smart_project_button.dart';

/// Responsive project details page presenting the full description, role,
/// key features, tech stack, and interactive screenshot gallery with lightbox.
class ProjectDetailsScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final ScrollController _galleryScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _galleryScrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollGallery(bool left) {
    final offset = _galleryScrollController.offset + (left ? -320 : 320);
    _galleryScrollController.animateTo(
      offset.clamp(0.0, _galleryScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final validActions = widget.project.allValidActions;

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Lightweight ambient background
            const Positioned.fill(child: SubtleAmbientBackground()),

            // Content
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 48,
                  vertical: 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: Responsive.maxContentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Button
                        _buildTopBar(context),
                        verticalSpace(24),

                        // Project Header (Title, Production Badge, External Links)
                        _buildHeader(isMobile, validActions),
                        verticalSpace(32),

                        // Balanced Hero Cover Image (max height 400px desktop, 240px mobile)
                        _buildCover(isMobile),
                        verticalSpace(40),

                        // Overview & Two-Column Layout (Desktop) or Stacked (Mobile)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 960) {
                              return _buildMobileContent(validActions);
                            }
                            return _buildDesktopContent(validActions);
                          },
                        ),
                        verticalSpace(48),

                        // Screenshot Gallery (if available)
                        if (widget.project.screenshotAssets.isNotEmpty) ...[
                          _buildGallerySection(isMobile),
                          verticalSpace(48),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_rounded,
                size: 18,
                color: AppColors.primaryCyan,
              ),
              SizedBox(width: 8),
              Text(
                AppStrings.backToProjects,
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile, List<ProjectAction> validActions) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    widget.project.title,
                    style: TextStyle(
                      fontSize: isMobile ? 26 : 38,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (widget.project.isProduction)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.success),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 14,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 6),
                          Text(
                            AppStrings.liveAppBadge,
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.project.shortDescription,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.secondaryText,
                  height: 1.5,
                ),
              ),
              if (isMobile && validActions.isNotEmpty) ...[
                verticalSpace(16),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: validActions
                      .map(
                        (action) =>
                            SmartProjectButton(action: action, isPrimary: true),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        if (!isMobile && validActions.isNotEmpty) ...[
          const SizedBox(width: 24),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: validActions
                .map(
                  (action) =>
                      SmartProjectButton(action: action, isPrimary: true),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildCover(bool isMobile) {
    final double maxCoverHeight = isMobile ? 240.0 : 400.0;
    final double aspectRatio = widget.project.coverAspectRatio;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dimensions so the container tightly hugs the image width and height
        double targetWidth = maxCoverHeight * aspectRatio;
        double targetHeight = maxCoverHeight;

        // If the calculated width exceeds available width, scale down proportionally
        if (targetWidth > constraints.maxWidth) {
          targetWidth = constraints.maxWidth;
          targetHeight = targetWidth / aspectRatio;
        }

        return Center(
          child: Container(
            width: targetWidth,
            height: targetHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF08121E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.glow.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  // Clickable cover image
                  GestureDetector(
                    onTap: () {
                      FullScreenImageViewer.show(
                        context,
                        images: [widget.project.coverAsset],
                        initialIndex: 0,
                        title: '${widget.project.title} - Cover',
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Center(
                        child: PortfolioImage(
                          assetPath: widget.project.coverAsset,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),

                  // Fullscreen zoom indicator button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Tooltip(
                      message: 'View full image',
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            FullScreenImageViewer.show(
                              context,
                              images: [widget.project.coverAsset],
                              initialIndex: 0,
                              title: '${widget.project.title} - Cover',
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.card.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.border.withValues(alpha: 0.8),
                              ),
                            ),
                            child: const Icon(
                              Icons.fullscreen_rounded,
                              size: 18,
                              color: AppColors.primaryCyan,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopContent(List<ProjectAction> validActions) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Overview & Key Features (62% width)
        Expanded(
          flex: 62,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewCard(),
              verticalSpace(24),
              _buildKeyFeaturesCard(),
            ],
          ),
        ),
        horizontalSpace(28),
        // Right Column: My Role, Project Links & Technologies Used (38% width)
        Expanded(
          flex: 38,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRoleAndInfoCard(validActions),
              verticalSpace(24),
              _buildTechStackCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileContent(List<ProjectAction> validActions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOverviewCard(),
        verticalSpace(20),
        _buildRoleAndInfoCard(validActions),
        verticalSpace(20),
        _buildKeyFeaturesCard(),
        verticalSpace(20),
        _buildTechStackCard(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.5,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primaryCyan,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Overview'),
          verticalSpace(14),
          Text(
            widget.project.fullDescription,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.secondaryText,
              height: 1.75,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleAndInfoCard(List<ProjectAction> validActions) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(AppStrings.myRole),
          verticalSpace(14),
          Text(
            widget.project.myRole,
            style: const TextStyle(
              fontSize: 14.5,
              color: AppColors.primaryText,
              height: 1.6,
            ),
          ),
          if (validActions.isNotEmpty) ...[
            verticalSpace(20),
            const Divider(color: AppColors.border, height: 1),
            verticalSpace(16),
            const Text(
              'Project Links',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryText,
                letterSpacing: 0.3,
              ),
            ),
            verticalSpace(12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: validActions
                  .map(
                    (action) => SmartProjectButton(
                      action: action,
                      isPrimary: true,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKeyFeaturesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(AppStrings.keyFeatures),
          verticalSpace(16),
          ...widget.project.keyFeatures.asMap().entries.map((entry) {
            final isLast = entry.key == widget.project.keyFeatures.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.all(3.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryCyan.withValues(alpha: 0.12),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: AppColors.primaryCyan,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: AppColors.primaryText,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTechStackCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(AppStrings.technologiesUsed),
          verticalSpace(16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.project.techStack.map((tech) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardHover,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Text(
                  tech,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.primaryCyan,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(bool isMobile) {
    final count = widget.project.screenshotAssets.length;
    final bool isLandscape = widget.project.screenshotAspectRatio > 1.2;
    final double galleryHeight = isLandscape
        ? (isMobile ? 180.0 : 260.0)
        : (isMobile ? 280.0 : 380.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('${AppStrings.screenshots} ($count)'),
            if (!isMobile && count > 3)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.primaryText,
                    ),
                    onPressed: () => _scrollGallery(true),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.primaryText,
                    ),
                    onPressed: () => _scrollGallery(false),
                  ),
                ],
              ),
          ],
        ),
        verticalSpace(16),
        SizedBox(
          height: galleryHeight,
          child: ListView.separated(
            controller: _galleryScrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: count,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final path = widget.project.screenshotAssets[index];
              return AspectRatio(
                aspectRatio: widget.project.screenshotAspectRatio,
                child: _GalleryItemCard(
                  assetPath: path,
                  onTap: () {
                    FullScreenImageViewer.show(
                      context,
                      images: widget.project.screenshotAssets,
                      initialIndex: index,
                      title: widget.project.title,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GalleryItemCard extends StatefulWidget {
  final String assetPath;
  final VoidCallback onTap;

  const _GalleryItemCard({required this.assetPath, required this.onTap});

  @override
  State<_GalleryItemCard> createState() => _GalleryItemCardState();
}

class _GalleryItemCardState extends State<_GalleryItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered ? AppColors.primaryCyan : AppColors.border,
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primaryCyan.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: PortfolioImage(
                  assetPath: widget.assetPath,
                  fit: BoxFit.cover,
                ),
              ),
              if (_isHovered)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.card,
                        ),
                        child: const Icon(
                          Icons.fullscreen_rounded,
                          color: AppColors.primaryCyan,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
