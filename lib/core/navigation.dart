import 'package:flutter/material.dart';

void navigateTo(
  BuildContext context,
  String route, {
  bool clear = false,
  Object? arguments,
}) {
  if (clear) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(route, (_) => false, arguments: arguments);
  } else {
    Navigator.of(context).pushNamed(route, arguments: arguments);
  }
}
