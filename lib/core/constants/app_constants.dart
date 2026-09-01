/// App-wide constants
class AppConstants {
  // Database
  static const String databaseName = 'syntrophe.db';
  
  // Hive boxes
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';
  
  // Animation durations
  static const int themeSwitchDurationMs = 300;
  static const int defaultAnimationDurationMs = 250;
  
  // Scripture reference pattern
  static const String scripturePattern = r'\b(\d?\s?[A-Za-z]+)\s+(\d+):(\d+)(?:-(\d+))?\b';
  
  // Notification channel IDs
  static const String alarmChannelId = 'syntrophe_alarms';
  static const String reminderChannelId = 'syntrophe_reminders';
  
  // Speech-to-text
  static const String localeCode = 'en-US';
  
  // Video player
  static const Duration videoAutoHideControls = Duration(seconds: 3);
}
