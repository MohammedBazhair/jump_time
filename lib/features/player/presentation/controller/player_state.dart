import '../../domain/entities/player_entity/player.dart';

class PlayerState {
  PlayerState({required this.readyPlayer, required this.players});

  factory PlayerState.empty() {
    return PlayerState(readyPlayer: Player.empty(), players: {});
  }

  final Map<int,Player> players;
  final Player readyPlayer;

  PlayerState copyWith({
    Map<int, Player>? players,
    Player? readyPlayer,
  }) {
    return PlayerState(
      players: players ?? this.players,
      readyPlayer: readyPlayer ?? this.readyPlayer,
    );
  }
}
