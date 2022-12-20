import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'player_manager.dart';
import 'services/service_locator.dart';
import 'utils/app_colors.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({ super.key });

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> with TickerProviderStateMixin {
  late final AnimationController _controller;
  void initState() {
    super.initState();
    final _playerManager = getIt<PlayerManager>();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _playerManager.splashFinishNotifier.value = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.BACKGROUND_COLOR,
      child:
          Padding(
            padding: EdgeInsets.fromLTRB(
              0.25.sw, // left
              0.33.sh, // top
              0.25.sw, // right
              0.33, // bottom
            ),
            child:
              Lottie.asset(
                  'assets/animations/splash.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    // Configure the AnimationController with the duration of the
                    // Lottie file and start the animation.
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
              ),
        )
      );

  }
}