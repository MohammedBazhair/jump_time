import '../../../../routes/app_routes.dart';

class NotificationParams {
  const NotificationParams({
    required this.id,
    required this.viewRoute,
    required this.title,
    this.body,
  });

  final int id;
  final String title;
  final String? body;
  final ViewRoute viewRoute;
}

class ScehduledNotificationParams extends NotificationParams {
  const ScehduledNotificationParams({
    required super.id,
    required super.title,
    required super.viewRoute,
    super.body,
    required this.scheduledDateTime,
  });
  final DateTime scheduledDateTime;
}
