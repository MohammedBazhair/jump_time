import '../entities/notification_params.dart';
import '../repository/notification_repository.dart';

class ScheduleNotificationUseCase {
  ScheduleNotificationUseCase(this._repository);
  final NotificationRepository _repository;

  Future<void> call(ScehduledNotificationParams params) {
    return _repository.scheduleNotification(params);
  }
}
