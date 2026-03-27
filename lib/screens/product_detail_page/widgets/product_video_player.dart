import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hyper_local/screens/product_detail_page/widgets/video_player_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProductVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isActive;

  const ProductVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.isActive,
  });

  @override
  State<ProductVideoPlayer> createState() => _ProductVideoPlayerState();
}

class _ProductVideoPlayerState extends State<ProductVideoPlayer> with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  bool _isYouTube = false;
  bool _isInitialized = false;
  final _manager = VideoPlayerManager();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(ProductVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle video URL change
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeControllers();
      _initializePlayer();
    }

    // Handle active state change
    if (oldWidget.isActive != widget.isActive) {
      _handleActiveStateChange();
    }
  }

  void _initializePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId != null) {
      // YouTube video
      _isYouTube = true;
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          loop: true,
          controlsVisibleAtStart: false,
          hideControls: true,
          disableDragSeek: true,
          enableCaption: false,
        ),
      );

      _manager.youtubeController = _youtubeController;

      setState(() {
        _isInitialized = true;
      });
    } else {
      // Regular video
      _isYouTube = false;
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
        )
      )..initialize().then((_) {
        _manager.videoPlayerController = _videoController;
        _manager.play();
        _manager.videoPlayerController!.setLooping(true);
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }).catchError((error) {
        log('Video initialization error: $error');
      });
    }
  }

  void _handleActiveStateChange() {
    if (!mounted) return;
    
    if (widget.isActive) {
      // Only control if this widget's controllers are the active ones
      if ((_isYouTube && _manager.youtubeController == _youtubeController) ||
          (!_isYouTube && _manager.videoPlayerController == _videoController)) {
        _manager.play();
        _manager.seekToStart();
      }
    } else {
      // Only pause if this widget's controllers are the active ones
      if ((_isYouTube && _manager.youtubeController == _youtubeController) ||
          (!_isYouTube && _manager.videoPlayerController == _videoController)) {
        _manager.pause();
      }
    }
  }

  void _disposeControllers() {
    // Only clear manager references if they point to our controllers
    if (_manager.youtubeController == _youtubeController) {
      _manager.youtubeController = null;
    }
    if (_manager.videoPlayerController == _videoController) {
      _manager.videoPlayerController = null;
    }
    _youtubeController?.dispose();
    _videoController?.dispose();
    _youtubeController = null;
    _videoController = null;
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_isYouTube && _youtubeController != null) {
      return YoutubePlayer(
        controller: _youtubeController!,
        showVideoProgressIndicator: false,
        progressIndicatorColor: Colors.transparent,
        progressColors: const ProgressBarColors(
          playedColor: Colors.transparent,
          handleColor: Colors.transparent,
          bufferedColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        bottomActions: const [],
        topActions: const [],
      );
    } else if (_videoController != null && _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    }

    return Container(
      color: Colors.black,
      child: const Center(
        child: Icon(Icons.error, color: Colors.white, size: 48),
      ),
    );
  }
}