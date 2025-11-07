import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/presentation/widget/iconed_button.dart';
import '../../../domain/entities/playing_method.dart';
import '../../../domain/entities/time_extend_entity.dart';
import '../../controller/player_controller.dart';
import '../custom_tab.dart';
import '../form_fields/money_form_field.dart';
import '../form_fields/playing_time_form_field.dart';
import '../inherited_widget/player_controllers_provider.dart';
import '../inherited_widget/player_id_provider.dart';

class ExtendTimeForm extends StatefulWidget {
  const ExtendTimeForm({super.key});

  @override
  State<ExtendTimeForm> createState() => _ExtendTimeFormState();
}

class _ExtendTimeFormState extends State<ExtendTimeForm>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  final playingTimeController = TextEditingController();
  final playingMoneyController = TextEditingController();
  PlayingMethod extendMethod = PlayingMethod.money;
  late TabController tabController;
  late int playerId;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: PlayingMethod.values.length - 1,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playerId = PlayerIdProvider.of(context).playerId;
  }

  @override
  void dispose() {
    playingTimeController.dispose();
    playingMoneyController.dispose();
    tabController.dispose();
    super.dispose();
  }

  int get currentTab => tabController.index;

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(
              builder: (_) {
                final timeExtendMethods = PlayingMethod.values.where(
                  (m) => m != PlayingMethod.unlimited,
                );

                final tabs = timeExtendMethods
                    .map(
                      (method) => CustomTab(
                        playingMethod: method,
                        tabController: tabController,
                      ),
                    )
                    .toList();

                return Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: tabs,
                );
              },
            ),

            SizedBox(
              height: 80,
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),

                children: const [MoneyFormField(), PlayingTimeFormField()],
              ),
            ),

            Consumer(
              builder: (context, ref, child) {
                return IconedButton(
                  onPressed: () {
                    final isValidForm =
                        formKey.currentState?.validate() ?? false;

                    if (!isValidForm) return;

                    final controller = ref.read(playerProvider.notifier);
                    final player = ref.read(playerProvider).players[playerId];
                    if (player == null) return;

                    final extendParams = ExtendTimeParams(
                      playerId: playerId,
                      money: playingMoneyController.text.toInt,
                      minutes: playingTimeController.text.toInt,
                    );

                    controller.extendPlayerTime(extendParams);
                  },
                  icon: const Icon(Icons.restore_outlined),
                  label: 'تمديد اللعب',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
