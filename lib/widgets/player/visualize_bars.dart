import "package:flutter/material.dart";
import 'package:radio_kwvh/notifiers/play_button_notifier.dart';
import 'package:radio_kwvh/player_manager.dart';
import 'package:radio_kwvh/services/service_locator.dart';

class VisualizeBars extends StatelessWidget {
  final List<Color>? colors;
  final List<int>? duration;
  final int? barCount;
  final Curve? curve;

  const VisualizeBars({
    Key? key,
    @required this.colors,
    @required this.duration,
    @required this.barCount,
    this.curve = Curves.easeInQuad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(barCount!,
                (index) => VisualComponent(
                    curve: curve!,
                    duration: duration![index % 9],
                    color: colors![index % 7]
                )
        )
    );
  }
}

class VisualComponent extends StatefulWidget {
  final int? duration;
  final Color? color;
  final Curve? curve;

  const VisualComponent({Key? key, @required this.duration, @required this.color, @required this.curve})
      : super(key: key);

  @override
  _VisualComponentState createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent> with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? animationController;
  bool _isPlaying = false;
  Duration _currentDuration = Duration(milliseconds: 0);

  @override
  void initState() {
    super.initState();
    final playerManager = getIt<PlayerManager>();
    playerManager.progressNotifier.addListener(() {
      _currentDuration = playerManager.progressNotifier.value.buffered;
    });
    playerManager.playButtonNotifier.addListener(() {
      setState(() {
        _isPlaying = playerManager.playButtonNotifier.value == ButtonState.playing;
      });
    });
    animate();
  }

  @override
  void dispose() {
    animation!.removeListener(() {});
    animation!.removeStatusListener((status) {});
    animationController!.stop();
    animationController!.reset();
    animationController!.dispose();
    super.dispose();
  }

  void animate() {
    animationController = AnimationController(duration: Duration(milliseconds: widget.duration!), vsync: this);
    final curvedAnimation = CurvedAnimation(parent: animationController!, curve: widget.curve!);
    animation = Tween<double>(begin: 0, end: 40).animate(curvedAnimation)
      ..addListener(() {
        update();
      });
    animationController!.repeat(reverse: true);
  }

  void update() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // To prevent fickling we have to check both of playing state && buffered state
    return (_isPlaying && _currentDuration.inSeconds > 0) ?
        Container(
          width: 4,
          height: animation!.value,
          decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(0)),
        ) :
        Padding(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 0,),
          child:
            Container(
              width: 4,
              height: 5,
              decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(0)),
            )
        );
  }
}