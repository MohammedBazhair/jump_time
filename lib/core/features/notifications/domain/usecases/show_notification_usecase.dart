import '../entities/notification_params.dart';
import '../repository/notification_repository.dart';

class ShowNotificationUseCase {
  ShowNotificationUseCase(this._repository);
  final NotificationRepository _repository;

  Future<void> call(LocalNotificationParams params) {
    return _repository.showInstantNotification(params);
  }
}
