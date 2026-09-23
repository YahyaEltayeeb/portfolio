import 'package:flutter/material.dart';
import '../../../../core/animations/transitions/visibility_fade_slide.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/spacing.dart';
import 'hero_content.dart';
import 'portrait_container.dart';

/// The Hero/About section presenting Yahya Mohamed.
class HeroSection extends StatelessWidget {
  final VoidCallback onViewProjectsTap;

  const HeroSection({super.key, required this.onViewProjectsTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return VisibilityFadeSlide(
      visibilityKey: 'hero-section',
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 48,
            vertical: isMobile ? 40 : 80,
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const PortraitContainer(size: 280),
                    verticalSpace(36),
                    HeroContent(onViewProjectsTap: onViewProjectsTap),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 55,
                      child: HeroContent(onViewProjectsTap: onViewProjectsTap),
                    ),
                    horizontalSpace(48),
                    const Expanded(
                      flex: 45,
                      child: Center(child: PortraitContainer(size: 380)),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
