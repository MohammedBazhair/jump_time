import 'package:flutter/material.dart';

import '../../../../../core/presentation/widget/custom_form_field.dart';
import '../../validators/validators.dart';
import '../inherited_widget/player_form_provider.dart';


class PlayingTimeFormField extends StatelessWidget {
  const PlayingTimeFormField({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
     final formProvider = PlayerFormProvider.of(context);
    final playingTimeController = formProvider.playingTimeController;
    final currentTab = formProvider.tabController.index;

    return Row(
      spacing: 15,
      children: [
        Expanded(
          child: CustomFormField(
            controller: playingTimeController,
            hintText: '10',
            helperText: 'اقصى دقائق هي 90 دقيقة',
            maxLength: 2,
            textInputType: const TextInputType.numberWithOptions(),
            validator: (value) => playingTimeValidator(value, currentTab),
          ),
        ),
        const Text('دقائق'),
      ],
    );
  }
}
