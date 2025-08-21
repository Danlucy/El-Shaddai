import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  static const String _darkModeKey = 'dark_mode';
  static const String _notificationsKey = 'notifications';
  static const String _locationKey = 'location_services';
  static const String _languageKey = 'language';
  static const String _userNameKey = 'user_name';
  static const bool defaultNotifications = false;

  // Singleton pattern
  static SettingsState? _instance;
  static SettingsState get instance => _instance ??= SettingsState._();
  SettingsState._();

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  // Initialize SharedPreferences
  Future<bool> init() async {
    try {
      debugPrint('🔧 SettingsManager: Initializing...');

      if (_isInitialized) {
        debugPrint('✅ SettingsManager: Already initialized');
        return true;
      }

      // Add timeout to prevent infinite loading
      _prefs = await SharedPreferences.getInstance().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('⏰ SharedPreferences initialization timed out');
          throw Exception('SharedPreferences initialization timed out');
        },
      );

      _isInitialized = true;

      debugPrint('✅ SettingsManager: Successfully initialized');

      // Log current values with defaults
      debugPrint('📊 Current settings:');
      debugPrint(
        '   • notifications: ${getNotifications()} (default: $defaultNotifications)',
      );

      return true;
    } catch (e) {
      debugPrint('❌ SettingsManager initialization failed: $e');
      _isInitialized = false;
      return false;
    }
  }

  bool get isInitialized => _isInitialized;
  // Dark Mode
  Future<bool> setNotifications(bool value) async {
    try {
      if (!_isInitialized) await init();
      final result = await _prefs!.setBool(_notificationsKey, value);
      debugPrint('💾 Saved notifications: $value');
      return result;
    } catch (e) {
      debugPrint('❌ Error saving notifications: $e');
      return false;
    }
  }

  bool getNotifications() {
    try {
      if (!_isInitialized || _prefs == null) {
        debugPrint(
          '⚠️ SettingsManager not initialized, returning default notifications: $defaultNotifications',
        );
        return defaultNotifications;
      }

      final value = _prefs!.getBool(_notificationsKey) ?? defaultNotifications;
      debugPrint('📖 Read notifications: $value');
      return value;
    } catch (e) {
      debugPrint(
        '❌ Error reading notifications: $e, returning default: $defaultNotifications',
      );
      return defaultNotifications;
    }
  }

  // Clear all settings (for logout/reset)
  Future<bool> clearAll() async {
    try {
      if (!_isInitialized) await init();
      return await _prefs!.clear();
    } catch (e) {
      debugPrint('❌ Error clearing settings: $e');
      return false;
    }
  }

  // Remove specific setting
  Future<bool> removeSetting(String key) async {
    return await _prefs!.remove(key);
  }

  //PERMISSION
}
