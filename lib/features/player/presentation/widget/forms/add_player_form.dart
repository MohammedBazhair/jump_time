import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/presentation/domain/id_generator.dart';
import '../../../../../core/presentation/widget/custom_form_field.dart';
import '../../../../../core/presentation/widget/iconed_button.dart';
import '../../../../notification/domain/entities/message_type.dart';
import '../../../../notification/domain/entities/snackbar_params.dart';
import '../../../../notification/presentation/service/notification_service.dart';
import '../../../domain/entities/player_entity/player.dart';
import '../../../domain/entities/playing_method.dart';
import '../../controller/player_controller.dart';
import '../inherited_widget/player_controllers_provider.dart';
import '../keep_screen_switch.dart';
import 'playing_method_form.dart';

class AddPlayerForm extends StatefulWidget {
  const AddPlayerForm({super.key});

  @override
  State<AddPlayerForm> createState() => _AddPlayerFormState();
}

class _AddPlayerFormState extends State<AddPlayerForm>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  final playerNameController = TextEditingController();
  final playingTimeController = TextEditingController();
  final playingMoneyController = TextEditingController();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: PlayingMethod.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    playerNameController.dispose();
    playingTimeController.dispose();
    playingMoneyController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void _submitForm(WidgetRef ref) {
    final isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) return;

    final controller = ref.read(playerProvider.notifier);
    final readyPlayer = ref.read(playerProvider).readyPlayer;



    final player = Player(
      id: IdGenerator.nextId,
      name: playerNameController.text,
      avatarPhoto: readyPlayer.avatarPhoto,
      playMode: readyPlayer.playMode,
      playerStatus: readyPlayer.playerStatus,
    );

    controller.startPlaying(player);

    NotificationService().show(
      SnackBarParams(
        msg: 'تم إضافة ${player.name} للعبة',
        type: MessageType.success,
      ),
    );

    controller.changePhotoToAsset();
    formKey.currentState?.reset();

    final isKeepScreenOn = ref.read(keepScreenProvider);
    if (isKeepScreenOn) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PlayerFormProvider(
      playingMoneyController: playingMoneyController,
      playingTimeController: playingTimeController,
      tabController: tabController,
      child: Form(
        key: formKey,
        child: Column(
          spacing: 10,
          children: [
            CustomFormField(
              controller: playerNameController,
              hintText: 'اسم اللاعب',
              validator: (value) {
                final isEmpty = value?.isEmpty ?? true;
                return isEmpty ? 'يجب إدخال اسم اللاعب أولا' : null;
              },
            ),

            const PlayingMethodForm(),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: Consumer(
                builder: (context, ref, child) {
                  return IconedButton(
                    label: 'ابدأ اللعب',
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () => _submitForm(ref),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
