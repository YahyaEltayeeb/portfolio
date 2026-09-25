import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  VisibilityDetectorController.instance.updateInterval = const Duration(
    milliseconds: 50,
  );
  runApp(const YahyaPortfolioApp());
}
