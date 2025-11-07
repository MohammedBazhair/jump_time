import '../repository/notification_repository.dart';

class InitNotificationUsecase {
  InitNotificationUsecase(this._repository);
  final NotificationRepository _repository;

  Future<void> call() => _repository.init();
}
