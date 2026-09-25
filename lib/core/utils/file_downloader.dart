import 'file_downloader_stub.dart'
    if (dart.library.html) 'file_downloader_web.dart';

/// Platform-agnostic helper to open PDF files directly in a browser tab without downloading.
Future<void> viewPdfDocument(String assetPath, String directFileName) =>
    openPdfInBrowser(assetPath, directFileName);

/// Platform-agnostic helper (retained for compatibility).
Future<void> downloadFileFromAsset(
  String assetPath,
  String suggestedFileName,
) => openPdfInBrowser(assetPath, suggestedFileName);
