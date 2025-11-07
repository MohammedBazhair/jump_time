import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/local_notification_datasource.dart';
import 'data/repository/notification_repository_impl.dart';
import 'domain/repository/notification_repository.dart';
import 'domain/usecases/init_notification_usecase.dart';
import 'domain/usecases/schedule_notification_usecase.dart';
import 'domain/usecases/show_notification_usecase.dart';

final getIt = GetIt.instance;

void setupNotificationLocators() {
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    FlutterLocalNotificationsPlugin.new,
  );

  getIt.registerLazySingleton<LocalNotificationDataSource>(
    () => LocalNotificationDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => InitNotificationUsecase(getIt()));
  getIt.registerLazySingleton(() => ScheduleNotificationParams(getIt()));
  getIt.registerLazySingleton(() => ShowNotificationUseCase(getIt()));
}
