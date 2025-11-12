import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../game_timer/presentation/controller/player_timer_controller.dart';
import '../../../game_timer/presentation/controller/remainig_time_price.dart';
import '../../../notification/domain/entities/message_type.dart';
import '../../../notification/domain/entities/snackbar_params.dart';
import '../../../notification/presentation/service/notification_service.dart';
import '../../domain/entities/calculator.dart';
import '../../domain/entities/player_entity/player.dart';
import '../../domain/entities/player_entity/sub_entity/avatar_photo.dart';
import '../../domain/entities/player_entity/sub_entity/play_mode.dart';
import '../../domain/entities/player_status.dart';
import '../../domain/entities/time_extend_entity.dart';
import 'player_state.dart';

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier(this.ref, this.notificationService)
    : super(PlayerState.empty());

  final Ref ref;
  final NotificationService notificationService;

  void addPlayer(Player player) {
    final copiedPlayers = {...state.players};
    copiedPlayers.update(player.id, (p) => player, ifAbsent: () => player);
    state = state.copyWith(players: copiedPlayers);
  }

  void startPlaying(Player player) {
    addPlayer(player);

    final minutePrice = ref.read(minutePriceProvider);

    final playerCalculator = PlayerCalculator(
      player: player,
      minutePrice: minutePrice,
    );
    final updatedPlayer = player.copyWith(calculator: playerCalculator);

    ref.read(playerTimerProvider.notifier).startTimer(updatedPlayer);
  }

  void changePlayingMethod(PlayMode playMode) {
    if (playMode.runtimeType == state.readyPlayer.playMode.runtimeType) return;

    final readyPlayer = state.readyPlayer.copyWith(playMode: playMode);

    state = state.copyWith(readyPlayer: readyPlayer);
  }

  void changeReadyPhoto(AvatarPhoto playerPhoto) {
    if (playerPhoto is AssetAvatar) return;

    final readyPlayer = state.readyPlayer.copyWith(avatarPhoto: playerPhoto);

    state = state.copyWith(readyPlayer: readyPlayer);
  }

  void changePlayerPhoto(int playerId, AvatarPhoto newPhoto) {
    if (newPhoto is AssetAvatar) return;

    final copiedPlayers = {...state.players};
    copiedPlayers.update(playerId, (p) => p.copyWith(avatarPhoto: newPhoto));

    state = state.copyWith(players: copiedPlayers);
  }

  void changePlayerStatus(int playerId, PlayerStatus newStatus) {
    final copiedPlayers = {...state.players};
    copiedPlayers.update(playerId, (p) => p.copyWith(playerStatus: newStatus));

    state = state.copyWith(players: copiedPlayers);
  }

  void changePhotoToAsset() {
    final currentPhoto = state.readyPlayer.avatarPhoto;
    if (currentPhoto is AssetAvatar) return;

    final newPlayer = state.readyPlayer.copyWith(avatarPhoto: AssetAvatar());

    state = state.copyWith(readyPlayer: newPlayer);
  }

  void deletePlayer(int playerId) {
    final copiedPlayers = {...state.players};
    final player = copiedPlayers.remove(playerId);

    ref.read(playerTimerProvider.notifier).deletePlayerTimer(playerId);
    state = state.copyWith(players: copiedPlayers);

    final playerName = player?.name ?? '';
    notificationService.show(
      SnackBarParams(
        msg: 'تم حذف اللاعب $playerName',
        type: MessageType.success,
      ),
    );
  }

  void extendPlayerTime(ExtendTimeParams extendParams) {
    final player = state.players[extendParams.playerId];
    if (player == null) return;
    try {
      final minutePrice = ref.read(minutePriceProvider);
      final calculator = PlayerCalculator(
        minutePrice: minutePrice,
        player: player,
      );
      final updatedPlayer = calculator.extendPlaying(extendParams);

      final playerWithCalculator = updatedPlayer.copyWith(
        calculator: calculator.copyWith(player: updatedPlayer),
      );

      addPlayer(playerWithCalculator);

      notificationService.show(
        SnackBarParams(
          msg: 'تم تمديد فترة اللاعب ${player.name}',
          type: MessageType.success,
        ),
      );
    } catch (_) {
      notificationService.show(
        SnackBarParams(
          msg: 'حدث خطأ أثناء محاولة تمديد فترة اللاعب ${player.name}',
          type: MessageType.error,
        ),
      );
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerState>(
  (ref) => PlayerNotifier(ref, ref.watch(notificationServiceProvider)),
);
