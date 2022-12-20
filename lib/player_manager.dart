import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_kwvh/notifiers/volume_notifier.dart';
import 'package:volume_controller/volume_controller.dart';
import '/notifiers/splash_finished_notifier.dart';
import '/notifiers/play_button_notifier.dart';
import '/notifiers/progress_notifier.dart';
import 'package:audio_service/audio_service.dart';
import '/services/service_locator.dart';

class PlayerManager {
  // Listeners: Updates going to the UI
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final playButtonNotifier = PlayButtonNotifier();
  final splashFinishNotifier = SplashFinishedNotifier();
  final volumeNotifier = VolumeNotifier();

  final _audioHandler = getIt<AudioHandler>();

  // Events: Calls coming from the UI
  void init() async {
    await _loadPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _initVolumeNotifier();
  }

  void _initVolumeNotifier() {
    VolumeController().getVolume().then((volume) => volumeNotifier.value = volume);
    VolumeController().listener((volume) {
      volumeNotifier.value = volume;
    });
  }

  Future<void> _loadPlaylist() async {
    final mediaItems = [
      const MediaItem(
        id: 'live-stream',
        title: 'KWVH',
        album: 'Live stream',
        extras: {'url': 'https://ice41.securenetsystems.net/KWVH' },
      )
    ];
    await _audioHandler.addQueueItems(mediaItems);
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;

      if (playbackState.playing &&
          playbackState.processingState != ProcessingState.idle &&
          playbackState.processingState != ProcessingState.completed
      ) {
        _audioHandler.customAction('start_visualize');
      } else {
        _audioHandler.customAction('stop_visualize');
      }

      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  Future<void> play() async {
    _audioHandler.play();
  }

  void setVolume(double volume) {
    _audioHandler.customAction('setVolume', { 'volume': volume });
  }

  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }
}
