import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/data/sample_data.dart';
import '../../models/district_model.dart';
import '../../responsive/responsive_layout.dart';
import '../../widgets/neon_glow_widget.dart';
import '../district_detail/district_detail_screen.dart';
import 'widgets/district_node_widget.dart';
import 'widgets/map_background_widget.dart';
import 'widgets/status_bar_widget.dart';

class CityMapScreen extends StatefulWidget {
  const CityMapScreen({super.key});

  @override
  State<CityMapScreen> createState() => _CityMapScreenState();
}

class _CityMapScreenState extends State<CityMapScreen> {
  bool _listView = false;

  void _onDistrictTap(DistrictModel district) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DistrictDetailScreen(district: district),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isMobile = ResponsiveLayout.isMobile(context);

    return MapBackgroundWidget(
      child: Column(
        children: [
          // Top bar
          _buildTopBar(isMobile),
          // Main content
          Expanded(
            child: isMobile
                ? _buildMobileLayout()
                : _listView
                    ? _buildListLayout()
                    : _buildMapLayout(isDesktop),
          ),
          // Stats bar (desktop/tablet only)
          if (!isMobile)
            _buildStatsBar()
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 12,
      ),
      child: Row(
        children: [
          // Status
          const StatusBarWidget(),
          const Spacer(),
          // View toggle (desktop only)
          if (!isMobile)
            _buildViewToggle()
                .animate()
                .fadeIn(duration: 400.ms),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3);
  }

  Widget _buildViewToggle() {
    return GestureDetector(
      onTap: () => setState(() => _listView = !_listView),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _listView ? Icons.map_outlined : Icons.view_list,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              _listView ? 'Map View' : 'List View',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapLayout(bool isWide) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Center branding
            Positioned(
              left: constraints.maxWidth * 0.35,
              top: constraints.maxHeight * 0.25,
              child: _buildCenterBrand()
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 800.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
            ),
            // District nodes positioned on map
            ...SampleData.districts.asMap().entries.map((entry) {
              final index = entry.key;
              final district = entry.value;

              return Positioned(
                left: district.mapPosition.dx * constraints.maxWidth -
                    (district.mapPosition.dx > 0.5 ? 80 : 0),
                top: district.mapPosition.dy *
                    (constraints.maxHeight - 80),
                child: DistrictNodeWidget(
                  district: district,
                  onTap: () => _onDistrictTap(district),
                )
                    .animate()
                    .fadeIn(
                      delay: (200 + index * 120).ms,
                      duration: 500.ms,
                    )
                    .slideY(
                      begin: 0.2,
                      delay: (200 + index * 120).ms,
                    ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildListLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: SampleData.districts.asMap().entries.map((entry) {
          final index = entry.key;
          final district = entry.value;
          return SizedBox(
            width: 280,
            child: _buildListCard(district)
                .animate()
                .fadeIn(delay: (80 * index).ms, duration: 400.ms)
                .slideY(begin: 0.1),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListCard(DistrictModel district) {
    return GestureDetector(
      onTap: () => _onDistrictTap(district),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: district.accentColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: district.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(district.icon,
                      color: district.accentColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    district.name.replaceAll('\n', ' '),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              district.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            ...district.highlights.take(3).map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: district.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        h,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: district.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore',
                    style: TextStyle(
                      color: district.accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward,
                      size: 12, color: district.accentColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Title
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
          child: Column(
            children: [
              const SizedBox(height: 8),
              NeonText(
                text: AppStrings.appName.toUpperCase(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                AppStrings.subtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: AppDimensions.spacingMd),
        // District grid for mobile
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppDimensions.spacingMd),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: SampleData.districts.length,
            itemBuilder: (context, index) {
              final district = SampleData.districts[index];
              return DistrictNodeWidget(
                district: district,
                onTap: () => _onDistrictTap(district),
                isCompact: true,
              )
                  .animate()
                  .fadeIn(delay: (100 * index).ms, duration: 400.ms)
                  .slideY(begin: 0.2);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCenterBrand() {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withValues(alpha: 0.08),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeonText(
            text: AppStrings.developerName.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Building Digital Solutions\nfor a Better Tomorrow',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.neonCyan.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border:
                  Border.all(color: AppColors.neonCyan.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.code,
              color: AppColors.neonCyan,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    final stats = [
      {'icon': Icons.apps, 'value': '6+', 'label': 'Applications Built'},
      {'icon': Icons.layers, 'value': '5', 'label': 'Industries Covered'},
      {'icon': Icons.code, 'value': '20+', 'label': 'Features Implemented'},
      {'icon': Icons.api, 'value': '100+', 'label': 'APIs Integrated'},
      {
        'icon': Icons.phone_android,
        'value': '50+',
        'label': 'Screens Designed'
      },
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((stat) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                stat['icon'] as IconData,
                color: AppColors.neonCyan,
                size: 18,
              ),
              const SizedBox(height: 6),
              Text(
                stat['value'] as String,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                stat['label'] as String,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
