import '../../domain/entities/notification_params.dart';
import '../../domain/repository/notification_repository.dart';
import '../datasources/local_notification_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._dataSource);
  final LocalNotificationDataSource _dataSource;

  @override
  Future<void> init() => _dataSource.init();

  @override
  Future<void> showInstantNotification(LocalNotificationParams params) {
    return _dataSource.showInstantNotification(params);
  }

  @override
  Future<void> scheduleNotification(ScehduledNotificationParams params) {
    return _dataSource.scheduleNotification(params);
  }
}
