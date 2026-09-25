// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Web implementation for opening PDF in a new browser tab without downloading.
Future<void> openPdfInBrowser(String assetPath, String directFileName) async {
  try {
    final anchor = html.AnchorElement(href: directFileName)
      ..target = '_blank'
      ..rel = 'noopener noreferrer';
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  } catch (_) {
    html.window.open(directFileName, '_blank');
  }
}

/// Retained for compatibility.
Future<void> downloadFile(String assetPath, String suggestedFileName) async {
  await openPdfInBrowser(assetPath, suggestedFileName);
}
