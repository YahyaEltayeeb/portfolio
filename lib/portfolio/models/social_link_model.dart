import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SocialPlatform { linkedIn, gitHub, whatsApp, email }

class SocialLinkModel {
  final SocialPlatform platform;
  final String name;
  final String url;
  final FaIconData icon;

  const SocialLinkModel({
    required this.platform,
    required this.name,
    required this.url,
    required this.icon,
  });

  static const FaIconData emailIcon = FontAwesomeIcons.envelope;
  static const FaIconData linkedInIcon = FontAwesomeIcons.linkedinIn;
  static const FaIconData gitHubIcon = FontAwesomeIcons.github;
  static const FaIconData whatsAppIcon = FontAwesomeIcons.whatsapp;
}
