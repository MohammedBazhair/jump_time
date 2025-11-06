import 'package:flutter/material.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/presentation/widget/iconed_button.dart';
import '../../../../core/routes/app_routes.dart';
import '../widget/inherited_widget/player_id_provider.dart';
import '../widget/player_manage/player_control_buttons.dart';
import '../widget/player_manage/player_current_money.dart';
import '../widget/player_manage/player_profile_avatar.dart';
import '../widget/player_manage/player_time_section.dart';

class PlayerManagementScreen extends StatelessWidget {
  const PlayerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة اللاعب')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const PlayerProfileAvatar(),

            const PlayerTimeSection(),

            const PlayerCurrentMoney(),
            const Divider(),

            const PlayerControlButtons(),

            IconedButton(
              label: 'تمديد فترة اللعب',
              icon: const Icon(Icons.restore),
              onPressed: () {
                final playerId = PlayerIdProvider.of(context).playerId;
                Navigator.of(context).pushNamed(
                  ViewRoute.extendTime.routeName,
                  arguments: playerId,
                );
              },
            ),
           
          ].withSpacing(30),
        ),
      ),
    );
  }
}
