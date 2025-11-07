import '../entities/notification_params.dart';
import '../repository/notification_repository.dart';

class ShowNotificationUseCase {
  ShowNotificationUseCase(this._repository);
  final NotificationRepository _repository;

  Future<void> call(NotificationParams params) {
    return _repository.showInstantNotification(params);
  }
}
