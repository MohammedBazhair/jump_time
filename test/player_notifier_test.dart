import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jump_time/features/notification/domain/entities/message_type.dart';
import 'package:jump_time/features/notification/domain/entities/snackbar_params.dart';
import 'package:jump_time/features/notification/presentation/service/notification_service.dart';
import 'package:jump_time/features/player/domain/entities/player_entity.dart';
import 'package:jump_time/features/player/domain/entities/player_photo/player_photo.dart';
import 'package:jump_time/features/player/domain/entities/player_status.dart';
import 'package:jump_time/features/player/domain/entities/playing_method.dart';
import 'package:jump_time/features/player/domain/entities/time_extend_entity.dart';
import 'package:jump_time/features/player/presentation/controller/player_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PlayerNotifier notifier;
  late ProviderContainer container;
  late MockNotificationService mockNotification;

  setUpAll(() {
    registerFallbackValue(SnackBarParams(msg: '', type: MessageType.warning));
  });

  setUp(() {
    mockNotification = MockNotificationService();

    when(() => mockNotification.show(any())).thenReturn(null);

    container = ProviderContainer.test(
      overrides: [
        notificationServiceProvider.overrideWithValue(mockNotification),
      ],
    );

    notifier = container.read(playerProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('PlayerNotifier logic tests', () {
    // test('addPlayer يضيف اللاعب إلى الحالة', () {
    //   final player = PlayerEntity(
    //     id: 1,
    //     name: 'فهد',
    //     playerPhoto: PlayerPhoto.asset(),
    //     playingMethod: PlayingMethod.money,
    //     playerStatus: PlayerStatus.playing,
    //     remainigTime: const Duration(minutes: 6),
    //     totalDuration: const Duration(minutes: 8),
    //   );

    //   notifier.addPlayer(player);

    //   final state = container.read(playerProvider);
    //   final id = player.id;
    //   expect(state.players.containsKey(id), true);
    //   expect(state.players[id]!.name, 'فهد');
    // });

    test('extendPlayerTime يمدد الوقت ويظهر رسالة نجاح', () {
      final player = PlayerEntity(
        id: 1,
        name: 'أحمد',
        playerPhoto: PlayerPhoto.asset(),
        playingMethod: PlayingMethod.time,
        playerStatus: PlayerStatus.playing,
        remainigTime: const Duration(minutes: 6),
        totalDuration: const Duration(minutes: 8),
        elapsedTime: const Duration(minutes: 2),
      );

      notifier.addPlayer(player);

      final extendParams = ExtendTimeParams(playerId: player.id,minutes: 10, money: null);

      notifier.extendPlayerTime( extendParams);

      final state = container.read(playerProvider);
      final updated = state.players[player.id];

      expect(updated?.totalDuration, equals(const Duration(minutes: 18)));

      verify(() {
        mockNotification.show(
          any(
            that: isA<SnackBarParams>()
                .having((e) => e.type, 'my type', MessageType.success)
                .having(
                  (e) => e.msg,
                  'msg',
                  contains('تم تمديد فترة اللاعب أحمد'),
                ),
          ),
        );
      }).called(1);
    });
  });
}
