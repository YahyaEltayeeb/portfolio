import 'file_downloader_stub.dart'
    if (dart.library.html) 'file_downloader_web.dart';

/// Platform-agnostic helper to trigger file download from Flutter assets.
Future<void> downloadFileFromAsset(
  String assetPath,
  String suggestedFileName,
) =>
    downloadFile(assetPath, suggestedFileName);
