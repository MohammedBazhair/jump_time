import 'package:flutter/material.dart';

class PlayerIdProvider extends InheritedWidget {
  const PlayerIdProvider({
    super.key,
    required super.child,
    required this.playerId,
  });

  final int playerId;

  static PlayerIdProvider of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<PlayerIdProvider>();

    assert(result != null, 'No PlayerIdProvider found in context');

    return result!;
  }

  @override
  bool updateShouldNotify(PlayerIdProvider oldWidget) {
    return playerId != oldWidget.playerId;
  }
}
