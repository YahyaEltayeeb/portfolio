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
            trimmed.startsWith('tel:'));
  }
}
