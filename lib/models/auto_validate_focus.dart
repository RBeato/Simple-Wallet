import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final autoValidateProvider =
    StateNotifierProvider<AutoValidateFocusProvider, AutovalidateMode>(
        (_) => AutoValidateFocusProvider());

class AutoValidateFocusProvider extends StateNotifier<AutovalidateMode> {
  AutoValidateFocusProvider() : super(AutovalidateMode.onUserInteraction);

  setMode(AutovalidateMode _mode) {
    state = _mode;
    print("AutovalidateMode state changed: $state");
  }
}
