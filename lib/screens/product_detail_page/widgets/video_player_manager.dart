import 'dart:ui';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerManager {
  static final VideoPlayerManager _instance = VideoPlayerManager._internal();
  factory VideoPlayerManager() => _instance;
  VideoPlayerManager._internal();

  // Hold references to active controllers
  YoutubePlayerController? youtubeController;
  VideoPlayerController? videoPlayerController;

  // Optional: callback when state changes
  VoidCallback? onPlayerStateChanged;

  void play() {
    youtubeController?.play();
    videoPlayerController?.play();
    onPlayerStateChanged?.call();
  }

  void pause() {
    youtubeController?.pause();
    videoPlayerController?.pause();
    onPlayerStateChanged?.call();
  }

  void mute() {
    youtubeController?.mute();
    videoPlayerController?.setVolume(0);
  }

  void unmute() {
    youtubeController?.unMute();
    videoPlayerController?.setVolume(1.0);
  }

  void seekToStart() {
    youtubeController?.seekTo(Duration.zero);
    videoPlayerController?.seekTo(Duration.zero);
  }

  void disposeAll() {
    youtubeController?.dispose();
    videoPlayerController?.dispose();
    youtubeController = null;
    videoPlayerController = null;
  }
}