import 'package:flutter/material.dart';

extension Themes on BuildContext {
  TextTheme get textTheme => TextTheme.of(this);
}

extension Numbers on String {
  int? get toInt => int.tryParse(this);
}

extension DurationFormat on Duration {
  String get format {
    final parts = toString().split('.'); // 00:00:00.00
    final clock = parts.first.split(':'); // 00:00:00=> hh:MM:ss
    final hours = clock[0].length == 1 ? '0${clock[0]}' : clock[0];
    final minutes = clock[1];
    // final seconds = clock[2];

    return '$hours:$minutes';
  }

  Duration increeseMinute() => Duration(minutes: inMinutes + 1);
  Duration decreeseMinute() => Duration(minutes: inMinutes - 1);
}

extension ListSpacing on List<Widget> {
  List<Widget> withSpacing(double spacing) {
    if (isEmpty) return this;
    final spacedList = <Widget>[];
    for (var i = 0; i < length; i++) {
      spacedList.add(this[i]);
      if (i < length - 1) {
        spacedList.add(SizedBox(height: spacing));
      }
    }
    return spacedList;
  }
}
