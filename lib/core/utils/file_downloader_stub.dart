import 'package:url_launcher/url_launcher.dart';

/// Non-web fallback stub for opening PDF files.
Future<void> openPdfInBrowser(String assetPath, String directFileName) async {
  final uri = Uri.tryParse(directFileName);
  if (uri != null) {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}

/// Retained for compatibility.
Future<void> downloadFile(String assetPath, String suggestedFileName) async {
  await openPdfInBrowser(assetPath, suggestedFileName);
}
