import 'package:flutter/material.dart';
import '../../../core/animations/routes/fade_route.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_assets.dart';
import 'portfolio_main_screen.dart';

/// Animated splash screen featuring the "YM" monogram with cinematic transitions.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _hasNavigated = false;

  // (1) Accent line expand
  late final Animation<double> _lineExpand;

  // (2) Monogram letters ("Y" and "M")
  late final Animation<double> _letterYOpacity;
  late final Animation<Offset> _letterYSlide;
  late final Animation<double> _letterMOpacity;
  late final Animation<Offset> _letterMSlide;

  // (3) Subtitle fade
  late final Animation<double> _subtitleOpacity;

  // (4) Accent line contract
  late final Animation<double> _lineContract;

  // (5) Exit scale + fade
  late final Animation<double> _exitScale;
  late final Animation<double> _exitOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // (1) Line expands: 0.0 -> 0.35
    _lineExpand = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
      ),
    );

    // (2)(a): "Y" appears: 0.10 -> 0.40
    _letterYOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.40, curve: Curves.easeOut),
      ),
    );
    _letterYSlide =
        Tween<Offset>(begin: const Offset(-0.4, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.10, 0.40, curve: Curves.easeOutCubic),
          ),
        );

    // (2)(b): "M" appears: 0.18 -> 0.48
    _letterMOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.48, curve: Curves.easeOut),
      ),
    );
    _letterMSlide =
        Tween<Offset>(begin: const Offset(0.4, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.18, 0.48, curve: Curves.easeOutCubic),
          ),
        );

    // (3) Subtitle fades in: 0.40 -> 0.68
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.68, curve: Curves.easeOut),
      ),
    );

    // (4) Line contracts: 0.65 -> 0.82
    _lineContract = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 0.82, curve: Curves.easeInCubic),
      ),
    );

    // (5) Exit: 0.78 -> 1.0
    _exitScale = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.78, 1.0, curve: Curves.easeInCubic),
      ),
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.80, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToHome();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(AppAssets.profileImage), context);
  }

  void _navigateToHome() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;
    Navigator.of(context).pushReplacement(
      FadeRoute(
        page: const PortfolioMainScreen(),
        transitionDurationCustom: const Duration(milliseconds: 150),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 768;
    final double logoFontSize = isMobile ? 72 : 100;
    final double subtitleFontSize = isMobile ? 12 : 14;
    final double lineMaxWidth = isMobile ? 120 : 180;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToHome,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final double lineProgress = _lineExpand.value * _lineContract.value;

            return FadeTransition(
              opacity: _exitOpacity,
              child: ScaleTransition(
                scale: _exitScale,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Monogram "YM"
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          SlideTransition(
                            position: _letterYSlide,
                            child: FadeTransition(
                              opacity: _letterYOpacity,
                              child: Text(
                                'Y',
                                style: AppTypography.heading(
                                  fontSize: logoFontSize,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryText,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                          SlideTransition(
                            position: _letterMSlide,
                            child: FadeTransition(
                              opacity: _letterMOpacity,
                              child: Text(
                                'M',
                                style: AppTypography.heading(
                                  fontSize: logoFontSize,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryCyan,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Accent cyan line
                      Container(
                        width: lineMaxWidth * lineProgress,
                        height: 2.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryCyan.withValues(alpha: 0.0),
                              AppColors.primaryCyan,
                              AppColors.primaryCyan.withValues(alpha: 0.0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Subtitle "YAHYA MOHAMED"
                      FadeTransition(
                        opacity: _subtitleOpacity,
                        child: Text(
                          AppStrings.name.toUpperCase(),
                          style: AppTypography.heading(
                            fontSize: subtitleFontSize,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 8,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ],
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
