import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/presentation/widget/iconed_button.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../domain/entities/player_entity/sub_entity/avatar_photo.dart';
import '../../controller/player_controller.dart';
import '../build_player_photo.dart';
import '../inherited_widget/player_id_provider.dart';

class PlayerCardHeader extends StatelessWidget {
  const PlayerCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final playerId = PlayerIdProvider.of(context).playerId;
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final playerPhoto = ref.watch(
                playerProvider.select(
                  (state) =>
                      state.players[playerId]?.avatarPhoto ?? AssetAvatar(),
                ),
              );
              return Positioned.fill(child: BuildPlayerPhoto(playerPhoto));
            },
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: SizedBox(
              height: 45,

              child: IconedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    ViewRoute.playerManagement.routeName,
                    arguments: playerId,
                  );
                },
                label: 'إدارة',
                icon: const Icon(Icons.manage_accounts),
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final playingMethod = ref.watch(
                playerProvider.select(
                  (state) => state.players[playerId]?.playMode.method,
                ),
              );
              return playingMethod != null
                  ? Positioned(
                      bottom: 15,
                      left: 15,
                      child: SizedBox(
                        height: 45,

                        child: IconedButton(
                          backgroundColor: const Color(0xFFE7EEF4),
                          foregroundColor: Colors.black,
                          onPressed: () {},
                          label: playingMethod.label,
                          icon: playingMethod.icon,
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
