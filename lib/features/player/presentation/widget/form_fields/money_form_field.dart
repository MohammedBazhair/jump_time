import 'package:flutter/material.dart';

import '../../../../../core/presentation/widget/custom_form_field.dart';
import '../../validators/validators.dart';
import '../inherited_widget/player_controllers_provider.dart';

class MoneyFormField extends StatelessWidget {
  const MoneyFormField({super.key});

  @override
  Widget build(BuildContext context) {
    final formProvider = PlayerFormProvider.of(context);
    final playingMoneyController = formProvider.playingMoneyController;
    final currentTab = formProvider.tabController.index;

    return Row(
      spacing: 15,
      children: [
        Expanded(
          child: CustomFormField(
            controller: playingMoneyController,
            hintText: '500',
            helperText: 'أقصى مبلغ هو 5000 ريال',
            maxLength: 4,
            textInputType: const TextInputType.numberWithOptions(),

            validator: (value) => playingMoneyValidator(value, currentTab),
          ),
        ),
        const Text('ريال'),
      ],
    );
  }
}
