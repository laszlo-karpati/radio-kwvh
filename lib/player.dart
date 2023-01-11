import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radio_kwvh/widgets/player/visualize.dart';
import '/notifiers/play_button_notifier.dart';
import '/player_manager.dart';
import '/services/service_locator.dart';
import '/utils/app_colors.dart';

import '/widgets/player/audio_controll.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:volume_controller/volume_controller.dart';


class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerManager = getIt<PlayerManager>();

    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          60.w, // left
          280.h, // top
          60.w, // right
          140.h, // bottom
        ),
        child:
        Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          'assets/svg/radio_tower_icon.svg',
                          semanticsLabel: 'KWVH Logo',
                          height: 180.h,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                      SizedBox(height: 80.h),
                      RichText(
                        text: TextSpan(
                          text: 'KVWH -',
                          style: DefaultTextStyle.of(context).style.copyWith(
                            color: AppColors.FOREIGN_COLOR,
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.w700,
                            fontSize: ScreenUtil().setSp(55),
                            decoration: TextDecoration.none,
                          ),
                          children: [
                            TextSpan(
                              text: ' 94.3 FM',
                              style:  DefaultTextStyle.of(context).style.copyWith(
                                color: AppColors.FOREIGN_COLOR,
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.w400,
                                fontSize: ScreenUtil().setSp(55),
                                decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 80.h),
                      ValueListenableBuilder<ButtonState>(
                        valueListenable: playerManager.playButtonNotifier,
                        builder: (_, value, __) {
                          switch (value) {
                            case ButtonState.loading:
                              return Text('Loading',
                                style: DefaultTextStyle.of(context).style.copyWith(
                                  color: AppColors.FOREIGN_COLOR,
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(55),
                                  decoration: TextDecoration.none,
                                ),
                              );
                            case ButtonState.paused:
                              return Text('Paused',
                                style: DefaultTextStyle.of(context).style.copyWith(
                                  color: AppColors.FOREIGN_COLOR,
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(55),
                                  decoration: TextDecoration.none,
                                ),
                              );
                            case ButtonState.playing:
                              return Text('Live',
                                style: DefaultTextStyle.of(context).style.copyWith(
                                  color: AppColors.FOREIGN_COLOR,
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(55),
                                  decoration: TextDecoration.none,
                                ),
                              );
                          }
                        },
                      ),
                      SizedBox(height: 350.h),
                      Visualize(),
                    ],
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AudioControlButtons(),
                  SizedBox(height: 60.h),
                  Row(children: [
                    SvgPicture.asset('assets/svg/volume_down.svg'),
                    Expanded(child:
                    ValueListenableBuilder<double>(
                        valueListenable: playerManager.volumeNotifier,
                        builder: (_, value, __) {
                          return Slider(
                            value: value,
                            divisions: 100,
                            onChanged: (newVolume) {
                              playerManager.volumeNotifier.value = newVolume;
                              if (timer != null) {
                                timer?.cancel();
                              }

                              //use timer for the smoother sliding
                              timer = Timer(Duration(milliseconds: 200), () {
                                VolumeController().setVolume(newVolume, showSystemUI: false);
                              });

                              print("new volume: ${newVolume}");
                            },
                            activeColor: AppColors.FOREIGN_COLOR,
                            inactiveColor: AppColors.INACTIVE_COLOR,
                            min: 0,
                            max: 1,
                          );
                        })
                    ),
                    SvgPicture.asset('assets/svg/volume_up.svg'),
                  ],)
                ],
              ),
            ]),
      ),
    );
  }
}