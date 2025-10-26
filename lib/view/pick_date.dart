import 'package:flutter/material.dart';

Future<DateTime?> pickDate(BuildContext context, {DateTime? initialDate}) async {
  final DateTime now = DateTime.now();
  final DateTime initial = initialDate ?? now;

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: now,
    lastDate: now.add(const Duration(days: 365)),
  );

  return picked;
}
