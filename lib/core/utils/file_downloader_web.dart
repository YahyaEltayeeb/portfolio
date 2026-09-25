// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/services.dart' show rootBundle;

/// Web implementation for downloading files from Flutter assets as a Blob.
Future<void> downloadFile(String assetPath, String suggestedFileName) async {
  try {
    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = '_blank'
      ..download = suggestedFileName;
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  } catch (_) {
    // Fallback: trigger download via direct URL
    final anchor = html.AnchorElement(href: 'yahya_mohamed_cv.pdf')
      ..target = '_blank'
      ..download = suggestedFileName;
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }
}
