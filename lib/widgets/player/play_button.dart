import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/notifiers/play_button_notifier.dart';
import '/player_manager.dart';
import '/services/service_locator.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _playerManager = getIt<PlayerManager>();
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/svg/play_pause_background.svg',
              semanticsLabel: 'KWVH Logo',
              height: 340.h,
              width: 340.w,
              allowDrawingOutsideViewBox: true,
            ),
            ValueListenableBuilder<ButtonState>(
              valueListenable: _playerManager.playButtonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.paused:
                    return IconButton(
                      icon: SvgPicture.asset('assets/svg/play.svg'),
                      iconSize: 150.w,
                      onPressed: _playerManager.play,
                    );
                  case ButtonState.loading:
                  case ButtonState.playing:
                    return IconButton(
                      icon: SvgPicture.asset('assets/svg/pause.svg'),
                      iconSize: 150.w,
                      onPressed: _playerManager.stop,
                    );
                }
              },
            ),
          ]
      ),
    );
   /*
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: Icon(Icons.play_arrow, color: Colors.black),
              iconSize: 32.0,
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: pageManager.stop,
            );
        }
      },
    ),;*/
  }
}
