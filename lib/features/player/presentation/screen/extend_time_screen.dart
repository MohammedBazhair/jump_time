import 'package:flutter/material.dart';

import '../widget/extend_time/extend_time_form.dart';

class ExtendTimeScreen extends StatelessWidget {
  const ExtendTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تمديد فترة اللاعب')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text(
            'كيف تود أن يتم تمديد فترة اللاعب؟',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          ExtendTimeForm(),
        ],
      ),
    );
  }
}
