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
            trimmed.startsWith('assets/'));
  }

  /// Triggers a download of Yahya's CV PDF.
  static Future<void> downloadCv() async {
    await downloadFileFromAsset(
      AppAssets.cvPdf,
      'Yahya_Mohamed_Flutter_Developer_CV.pdf',
    );
  }

  /// Safely open external or asset URL.
  static Future<void> openUrl(String? url) async {
    if (!isValid(url)) return;
    final trimmed = url!.trim();

    // If it's an asset (e.g. PDF CV), trigger direct download
    if (trimmed.startsWith('assets/')) {
      await downloadFileFromAsset(
        trimmed,
        'Yahya_Mohamed_Flutter_Developer_CV.pdf',
      );
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
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
