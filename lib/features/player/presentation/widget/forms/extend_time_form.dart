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

  late TabController tabController;
  late int playerId;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: PlayingMethod.values.length - 1,
      vsync: this,
    );

    playerId = PlayerIdProvider.of(context).playerId;
  }

  @override
  void dispose() {
    playingTimeController.dispose();
    playingMoneyController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void _submitForm(WidgetRef ref) {
    final isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) return;

    final controller = ref.read(playerProvider.notifier);

    final extendTimeParams = ExtendTimeParams(
      playerId: playerId,
      minutes: playingMoneyController.text.toInt,
      money: playingMoneyController.text.toInt,
    );

    controller.extendPlayerTime(extendTimeParams);

    Navigator.of(context).pop();
  }

  int get currentTab => tabController.index;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 20,
        children: [
          Consumer(
            builder: (_, ref, __) {
              final tabRecentIndex = ref.watch(
                playerProvider.select(
                  (state) => state.readyPlayer.playingMethod.index,
                ),
              );
              if (currentTab != tabRecentIndex) {
                tabController.animateTo(tabRecentIndex);
              }

              final tabs = PlayingMethod.values
                  .take(2)
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

          SizedBox(
            width: double.infinity,
            child: Consumer(
              builder: (context, ref, child) {
                return IconedButton(
                  label: 'تمديد',
                  icon: const Icon(Icons.restart_alt),
                  onPressed: () => _submitForm(ref),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
