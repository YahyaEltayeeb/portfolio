import 'package:url_launcher/url_launcher.dart';

/// Centralized external links for Yahya Mohamed's portfolio.
///
/// NOTE: Only LinkedIn, GitHub, and WhatsApp are supported.
/// Do not add email or any other platform.
abstract final class AppLinks {
  /// LinkedIn profile URL.
  static const String linkedIn =
      'https://www.linkedin.com/in/yahya-mohamed-yahyamohamed/';

  /// GitHub profile URL.
  static const String gitHub = 'https://github.com/YahyaEltayeeb';

  /// WhatsApp direct chat URL.
  static const String whatsApp = 'https://wa.me/201289078927';

  /// Utility validator to ensure buttons only render when a valid URL is present.
  static bool isValid(String? url) {
    if (url == null) return false;
    final trimmed = url.trim();
    return trimmed.isNotEmpty &&
        (trimmed.startsWith('http://') ||
            trimmed.startsWith('https://') ||
            trimmed.startsWith('mailto:') ||
            trimmed.startsWith('tel:') ||
            trimmed.startsWith('assets/'));
  }

  /// Safely open external or asset URL.
  static Future<void> openUrl(String? url) async {
    if (!isValid(url)) return;
    final uri = Uri.parse(url!.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
