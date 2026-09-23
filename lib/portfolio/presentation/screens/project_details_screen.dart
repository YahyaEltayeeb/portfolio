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

                        // Large Cover Image
                        _buildCover(),
                        verticalSpace(40),

                        // Overview & Two-Column Layout (Desktop) or Stacked (Mobile)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 960) {
                              return _buildMobileContent();
                            }
                            return _buildDesktopContent();
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
    return Column(
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
                fontSize: isMobile ? 24 : 36,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
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
        if (validActions.isNotEmpty) ...[
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
    );
  }

  Widget _buildCover() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
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
        child: AspectRatio(
          aspectRatio: widget.project.coverAspectRatio,
          child: Center(
            child: PortfolioImage(
              assetPath: widget.project.coverAsset,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Overview, Role, Key Features
        Expanded(
          flex: 65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Overview'),
              verticalSpace(12),
              Text(
                widget.project.fullDescription,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.secondaryText,
                  height: 1.7,
                ),
              ),
              verticalSpace(28),
              _buildRole(),
              verticalSpace(28),
              _buildKeyFeatures(),
            ],
          ),
        ),
        horizontalSpace(40),
        // Right Column: Tech Stack
        Expanded(flex: 35, child: _buildTechStack()),
      ],
    );
  }

  Widget _buildMobileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Overview'),
        verticalSpace(12),
        Text(
          widget.project.fullDescription,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.secondaryText,
            height: 1.7,
          ),
        ),
        verticalSpace(24),
        _buildRole(),
        verticalSpace(24),
        _buildKeyFeatures(),
        verticalSpace(28),
        _buildTechStack(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primaryCyan,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRole() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardHover.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.myRole,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryCyan,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.project.myRole,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primaryText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(AppStrings.keyFeatures),
        verticalSpace(12),
        ...widget.project.keyFeatures.map(
          (feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    size: 16,
                    color: AppColors.primaryCyan,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTechStack() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                    fontSize: 12,
                    color: AppColors.primaryText,
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
                  fit: BoxFit.contain,
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
