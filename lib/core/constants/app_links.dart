import 'package:url_launcher/url_launcher.dart';
import '../utils/file_downloader.dart';
import 'app_assets.dart';

/// Centralized external links for Yahya Mohamed's portfolio.
abstract final class AppLinks {
  /// Direct compose link for Gmail.
  static const String email =
      'https://mail.google.com/mail/?view=cm&fs=1&to=yahya.mobiledev@gmail.com';

  /// Email direct mailto link fallback.
  static const String mailto = 'mailto:yahya.mobiledev@gmail.com';

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
            trimmed.startsWith('assets/') ||
            trimmed.endsWith('.pdf'));
  }

  /// Opens Yahya's CV PDF directly in the browser viewer instead of forcing a download.
  static Future<void> downloadCv() async {
    await viewPdfDocument(AppAssets.cvPdf, 'yahya_mohamed_cv.pdf');
  }

  /// Safely open external or asset URL.
  static Future<void> openUrl(String? url) async {
    if (!isValid(url)) return;
    final trimmed = url!.trim();

    // If it's a CV or asset PDF, open in new tab instead of downloading
    if (trimmed == AppAssets.cvPdf || trimmed.endsWith('.pdf')) {
      await downloadCv();
      return;
    }

    final uri = Uri.parse(trimmed);
    if (trimmed.startsWith('mailto:') || trimmed.startsWith('tel:')) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    }
  }
}
