import 'package:flutter/material.dart';

extension Themes on BuildContext {
  TextTheme get textTheme => TextTheme.of(this);
}

extension Numbers on String {
  int? get toInt => int.tryParse(this);
}

extension DurationFormat on Duration {
  String get format {
    final parts = toString().split('.');
   return parts.first;
  }
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