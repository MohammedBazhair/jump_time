import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import '../../constants/notification_channels.dart';
import '../../domain/entities/notification_params.dart';

abstract class LocalNotificationDataSource {
  Future<void> init();
  Future<void> showInstantNotification(LocalNotificationParams params);
  Future<void> scheduleNotification(ScehduledNotificationParams params);
}

class LocalNotificationDataSourceImpl implements LocalNotificationDataSource {
  LocalNotificationDataSourceImpl(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<void> init() async {
    // ✅ تحميل كل بيانات المناطق الزمنية
    initializeTimeZones();

    // ✅ تحديد المنطقة الزمنية المحلية لليمن
    setLocalLocation(getLocation('Asia/Aden'));

    // ✅ إعدادات Android: استخدم أيقونة التطبيق الافتراضية
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // ✅ إعدادات iOS (Darwin)
    const iosSettings = DarwinInitializationSettings();

    // ✅ جمع الإعدادات للنظامين
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // ✅ تهيئة مكتبة الإشعارات
    await _plugin.initialize(initializationSettings);
  }

  @override
  Future<void> scheduleNotification(ScehduledNotificationParams params) async {
    final scheduledDate = TZDateTime.from(params.scheduledDateTime, local);
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationChannels.dailyId,
        NotificationChannels.dailyName,
        channelDescription: NotificationChannels.dailyDesc,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      params.title,
      params.body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  @override
  Future<void> showInstantNotification(LocalNotificationParams params) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationChannels.instantId,
        NotificationChannels.instantName,
        channelDescription: NotificationChannels.instantDesc,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      params.title,
      params.body,
      notificationDetails,
    );
  }
}
