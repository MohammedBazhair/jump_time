import 'package:flutter/material.dart';
import '../../features/player/presentation/screen/add_player_screen.dart';
import '../../features/player/presentation/screen/extend_time_screen.dart';
import '../../features/player/presentation/screen/player_management_screen.dart';
import '../../features/player/presentation/widget/inherited_widget/player_id_provider.dart';
import '../presentation/screen/home_layout_screen.dart';

class AppRoutes {
  AppRoutes._();



  static Map<String, WidgetBuilder> routes = {
    ViewRoute.home.routeName: (_) => const HomeLayoutScreen(),
    ViewRoute.addPlayer.routeName: (_) => const AddPlayerScreen(),
    ViewRoute.playerManagement.routeName: (context) {
      final playerId = ModalRoute.of(context)?.settings.arguments as int;
      return PlayerIdProvider(
        playerId: playerId,
        child: const PlayerManagementScreen(),
      );
    },
    ViewRoute.extendTime.routeName: (context) {
      final playerId = ModalRoute.of(context)?.settings.arguments as int;
      return PlayerIdProvider(
        playerId: playerId,
        child: const ExtendTimeScreen(),
      );
    },
  };
}

enum ViewRoute {
  home('/'),
  playersList('/playersList'),
  playerManagement('/playerManagement'),
  extendTime('/extendTime'),
  nextPlayers('/nextPlayers'),
  dailyReport('/dailyReport'),
  settings('/settings'),
  addPlayer('/appPlayer');

  const ViewRoute(this.routeName);
  final String routeName;
}
