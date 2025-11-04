import 'package:custom_snackbar_plus/custom_snackbar_plus.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/snackbar_params.dart';

class NotificationService {
  factory NotificationService() {
    return _instance;
  }
  NotificationService._();

  static final _instance = NotificationService._();

  final navigatorKey = GlobalKey<NavigatorState>();

  void show(SnackBarParams params) {
    if (navigatorKey.currentContext == null) return;
    if (!navigatorKey.currentContext!.mounted) return;
    CustomSnackbar.show(
      context: navigatorKey.currentContext!,
      title: params.msg,
      label: '',
      mode: NotificationMode.auto,
      duration: const Duration(seconds: 1),
      type: params.type.type,
    );
  }
}
