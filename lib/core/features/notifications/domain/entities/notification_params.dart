class LocalNotificationParams {
  const LocalNotificationParams({required this.title, this.body});

  final String title;
  final String? body;
}

class ScehduledNotificationParams extends LocalNotificationParams {
  const ScehduledNotificationParams({
    required super.title,
    super.body,
    required this.scheduledDateTime,
  });
  final DateTime scheduledDateTime;
}
