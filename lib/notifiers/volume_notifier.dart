import 'package:flutter/foundation.dart';

class VolumeNotifier extends ValueNotifier<double> {
  VolumeNotifier() : super(_initialValue);
  static const _initialValue = 0.5;
}