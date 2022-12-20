import 'package:flutter/foundation.dart';

class SplashFinishedNotifier extends ValueNotifier<bool> {
  SplashFinishedNotifier() : super(_initialValue);
  static const _initialValue = false;
}