import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/animations/transitions/visibility_fade_slide.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../../models/social_link_model.dart';
import '../../../repositories/social_links_repository.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  String _ctaForPlatform(SocialPlatform platform) {
    switch (platform) {
      case SocialPlatform.linkedIn:
        return "Let's Connect on LinkedIn";
      case SocialPlatform.gitHub:
        return 'Explore Code & Repositories';
      case SocialPlatform.whatsApp:
        return 'Chat Directly on WhatsApp';
    }
  }

  String _descriptionForPlatform(SocialPlatform platform) {
    switch (platform) {
      case SocialPlatform.linkedIn:
        return 'Professional updates, recommendations, and industry networking.';
      case SocialPlatform.gitHub:
        return 'Open source contributions, sample architectures, and projects.';
      case SocialPlatform.whatsApp:
        return 'Quick messaging, inquiries, and immediate direct communication.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final socialLinks = const SocialLinksRepository().getSocialLinks();

    return VisibilityFadeSlide(
      visibilityKey: 'contact-section',
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 48,
            vertical: isMobile ? 40 : 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section Header
              Text(
                AppStrings.contactTitle,
                style: GoogleFonts.poppins(
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
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 14 : 16,
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),

              // 3 Contact Cards (Strictly LinkedIn, GitHub, WhatsApp)
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return Column(
                      children: socialLinks.map((link) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _ContactCard(
                            link: link,
                            cta: _ctaForPlatform(link.platform),
                            description: _descriptionForPlatform(link.platform),
                          ),
                        );
                      }).toList(),
                    );
                  }

                  // Desktop Row
                  return Row(
                    children: socialLinks.map((link) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: _ContactCard(
                            link: link,
                            cta: _ctaForPlatform(link.platform),
                            description: _descriptionForPlatform(link.platform),
                          ),
                        ),
                      );
                    }).toList(),
                  );
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
  final SocialLinkModel link;
  final String cta;
  final String description;

  const _ContactCard({
    required this.link,
    required this.cta,
    required this.description,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => AppLinks.openUrl(widget.link.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.cardHover : AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primaryCyan.withValues(alpha: 0.6)
                  : AppColors.border,
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primaryCyan.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon container
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AppColors.primaryCyan.withValues(alpha: 0.2)
                      : AppColors.primaryCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primaryCyan.withValues(alpha: 0.35),
                  ),
                ),
                child: Center(
                  child: FaIcon(
                    widget.link.icon,
                    size: 24,
                    color: AppColors.primaryCyan,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                widget.link.name,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                widget.description,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // CTA with Arrow
              Row(
                children: [
                  Text(
                    widget.cta,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryCyan,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 200),
                    offset: _isHovered
                        ? const Offset(0.3, 0)
                        : const Offset(0, 0),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: AppColors.primaryCyan,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
