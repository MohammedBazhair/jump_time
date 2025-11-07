import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'core/features/notifications/domain/usecases/init_notification_usecase.dart';
import 'core/features/notifications/injection.dart';
import 'core/presentation/screen/material_app.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  setupNotificationLocators();
  await GetIt.I<InitNotificationUsecase>()();
  runApp(const ProviderScope(child: CustomMaterialApp()));
}
