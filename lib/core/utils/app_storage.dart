import 'package:hive_flutter/hive_flutter.dart';

/// Theme mode keys for Hive storage
class HiveKeys {
  static const String themeMode = 'theme_mode';
  static const String fontSize = 'font_size';
  static const String onboardingComplete = 'onboarding_complete';
}

/// Initialize Hive and load theme before runApp
Future<void> initializeApp() async {
  await Hive.initFlutter();
  
  // Register adapters here when needed
  // Hive.registerAdapter(YourAdapter());
  
  // Open boxes
  await Hive.openBox('settings');
  await Hive.openBox('cache');
}

/// Get saved theme mode from Hive
ThemeMode getSavedThemeMode() {
  final box = Hive.box('settings');
  final themeIndex = box.get(HiveKeys.themeMode, defaultValue: 0);
  return ThemeMode.values[themeIndex];
}

/// Save theme mode to Hive
Future<void> saveThemeMode(ThemeMode mode) async {
  final box = Hive.box('settings');
  await box.put(HiveKeys.themeMode, mode.index);
}

/// Get saved font size from Hive
double getSavedFontSize() {
  final box = Hive.box('settings');
  return box.get(HiveKeys.fontSize, defaultValue: 16.0);
}

/// Save font size to Hive
Future<void> saveFontSize(double size) async {
  final box = Hive.box('settings');
  await box.put(HiveKeys.fontSize, size);
}
