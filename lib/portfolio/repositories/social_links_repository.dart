import '../../core/constants/app_links.dart';
import '../../core/constants/app_strings.dart';
import '../models/social_link_model.dart';

class SocialLinksRepository {
  const SocialLinksRepository();

  List<SocialLinkModel> getSocialLinks() {
    return const [
      SocialLinkModel(
        platform: SocialPlatform.linkedIn,
        name: AppStrings.linkedIn,
        url: AppLinks.linkedIn,
        icon: SocialLinkModel.linkedInIcon,
      ),
      SocialLinkModel(
        platform: SocialPlatform.gitHub,
        name: AppStrings.gitHub,
        url: AppLinks.gitHub,
        icon: SocialLinkModel.gitHubIcon,
      ),
      SocialLinkModel(
        platform: SocialPlatform.whatsApp,
        name: AppStrings.whatsApp,
        url: AppLinks.whatsApp,
        icon: SocialLinkModel.whatsAppIcon,
      ),
    ];
  }
}
