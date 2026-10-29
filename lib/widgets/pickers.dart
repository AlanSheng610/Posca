import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';

const kGenders = ['Male', 'Female', 'Non-binary'];

/// Users must be at least 18.
void showBirthdatePicker(
  BuildContext context, {
  required ValueChanged<String> onSubmit,
}) {
  BottomPicker.date(
    title: 'Set your birthdate',
    titleStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.blue,
    ),
    minDateTime: DateTime(1900),
    maxDateTime: DateTime.now().subtract(const Duration(days: 18 * 365)),
    onSubmit: (date) => onSubmit(formatBirthdate(date as DateTime)),
    bottomPickerTheme: BottomPickerTheme.plumPlate,
  ).show(context);
}

void showGenderPicker(
  BuildContext context, {
  required ValueChanged<String> onSubmit,
}) {
  BottomPicker(
    items: [
      for (final gender in kGenders)
        Text(gender, style: const TextStyle(fontSize: 25)),
    ],
    title: 'Gender',
    titleAlignment: CrossAxisAlignment.center,
    titleStyle: const TextStyle(fontSize: 15),
    onSubmit: (index) => onSubmit(kGenders[index as int]),
    bottomPickerTheme: BottomPickerTheme.plumPlate,
    buttonAlignment: MainAxisAlignment.center,
  ).show(context);
}

String formatBirthdate(DateTime date) =>
    '${date.year}/${date.month}/${date.day}';
