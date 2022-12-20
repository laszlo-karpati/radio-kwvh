import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radio_kwvh/utils/app_colors.dart';
import 'player.dart';
import 'player_manager.dart';
import 'splash.dart';
import '/services/service_locator.dart';

void main() async {
  await setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _showSplash = true;
  PlayerManager playerManager = getIt<PlayerManager>();

  @override
  void initState() {
    super.initState();
    getIt<PlayerManager>().init();

    playerManager.splashFinishNotifier.addListener((  ) {
      setState(() {
        print('###### playerManager.splashFinishNotifier.value ' + playerManager.splashFinishNotifier.value.toString());
        _showSplash = !playerManager.splashFinishNotifier.value;
      });
    });
  }

  @override
  void dispose() {
    getIt<PlayerManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return
      ScreenUtilInit(
        designSize: const Size(1080, 2160),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context , child) {
          return MaterialApp(
              home: child
          );
        },
        child: Scaffold(
          backgroundColor: AppColors.BACKGROUND_COLOR,
          body: AnimatedCrossFade(
                  crossFadeState: _showSplash ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                  firstChild: Splash(),
                  secondChild: Player(),
              ),
        )
        /*
        child: ValueListenableBuilder<bool>(
          valueListenable: ,
          builder: (_, value, __) {
            return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: ? Player() : Splash()
            );
          }
        ),*/
      );
  }
}
