import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radio_kwvh/widgets/player/visualize_bars.dart';

class Visualize extends StatelessWidget {
  Visualize({ super.key });

  final List<Color> colors = List.filled(30, Colors.black);
  final List<int> duration = [653 , 900, 1260, 600, 1100, 954, 754, 844, 1055, 960, 1300,653 , 900, 1260, 600, 1100, 954, 754, 844, 1055, 960, 1300];

  @override
  Widget build(BuildContext context) {

    return SizedBox(width: 600.w,
        child: VisualizeBars(
      curve: Curves.fastOutSlowIn,
      barCount: 30,
      colors: colors,
      duration: duration,
    ));
  }
}