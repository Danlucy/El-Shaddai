import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;

/// NotificationsController handles all local notifications logic
class NotificationsController {
  NotificationsController._privateConstructor();
  static final NotificationsController instance =
      NotificationsController._privateConstructor();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _notificationsEnabled = false;

  /// Current permission state
  bool get notificationsEnabled => _notificationsEnabled;

  /// Initialize notifications plugin
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    // Combined initialization
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(settings);

    // Check existing permission on init
    _notificationsEnabled = await _checkPermission();

    _initialized = true;
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      _notificationsEnabled = result.isGranted;
      return result.isGranted;
    }
    _notificationsEnabled = true;
    return true;
  }

  /// Internal: check permission status
  Future<bool> _checkPermission() async {
    // Use permission_handler for both platforms
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// Schedule a notification 30 minutes before booking
}
