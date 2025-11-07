import '../entities/notification_params.dart';

abstract class NotificationRepository {
  Future<void> init();
  Future<void> showInstantNotification(NotificationParams params);
  Future<void> scheduleNotification(ScehduledNotificationParams params);
}
