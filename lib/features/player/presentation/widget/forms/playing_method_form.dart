import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/playing_method.dart';
import '../../controller/player_controller.dart';
import '../custom_tab.dart';
import '../form_fields/money_form_field.dart';
import '../form_fields/playing_time_form_field.dart';
import '../inherited_widget/player_form_provider.dart';

class PlayingMethodForm extends StatelessWidget {
  const PlayingMethodForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formProvider = PlayerFormProvider.of(context);
    final tabController = formProvider.tabController;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 30,
      children: [
        Consumer(
          builder: (_, ref, __) {
            final tabRecentIndex = ref.watch(
              playerProvider.select(
                (state) => state.readyPlayer.playMode.method.index,
              ),
            );
            if (tabController.index != tabRecentIndex) {
              tabController.animateTo(tabRecentIndex);
            }

            final tabs = PlayingMethod.values
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
            children: const [
              MoneyFormField(),

              PlayingTimeFormField(),

              Center(child: Text('تم اختيار مفتوح')),
            ],
          ),
        ),
      ],
    );
  }
}
