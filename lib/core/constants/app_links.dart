/// Centralized external links for Yahya Mohamed's portfolio.
///
/// NOTE: Only LinkedIn, GitHub, and WhatsApp are supported.
/// All URLs default to null until real profile links are provided.
abstract final class AppLinks {
  /// LinkedIn profile URL.
  // TODO: Provide real LinkedIn profile URL (e.g. 'https://www.linkedin.com/in/your-profile')
  static const String? linkedIn = null;

  /// GitHub profile URL.
  // TODO: Provide real GitHub profile URL (e.g. 'https://github.com/your-username')
  static const String? gitHub = null;

  /// WhatsApp direct chat URL.
  // TODO: Provide real WhatsApp URL (e.g. 'https://wa.me/your-number')
  static const String? whatsApp = null;

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
