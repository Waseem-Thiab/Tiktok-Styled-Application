import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
  }

  void _initializeVideo() {
    if (!_isInitialized) {
      videoPlayerController.initialize().then((_) {
        if (mounted) { // Check if the widget is still mounted
          setState(() {
            _isInitialized = true;
            videoPlayerController.setLooping(true);
            videoPlayerController.setVolume(1);
            if (_isVisible) {
              videoPlayerController.play();
              _isPlaying = true;
            }
          });
        }
      });
    }
  }

  void _handleVisibilityChange(bool isVisible) {
    setState(() {
      _isVisible = isVisible;
      if (_isVisible) {
        if (!_isInitialized) {
          _initializeVideo();
        } else {
          videoPlayerController.play();
          _isPlaying = true;
        }
      } else {
        if (_isInitialized) {
          videoPlayerController.pause();
          _isPlaying = false;
        }
      }
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        _handleVisibilityChange(info.visibleFraction > 0.5);
      },
      child: GestureDetector(
        onTap: () {
          if (_isVisible) {
            if (mounted) { // Check if the widget is still mounted
              setState(() {
                if (videoPlayerController.value.isPlaying) {
                  videoPlayerController.pause();
                  _isPlaying = false;
                } else {
                  videoPlayerController.play();
                  _isPlaying = true;
                }
              });
            }
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: _isInitialized
                  ? VideoPlayer(videoPlayerController)
                  : const Center(child: CircularProgressIndicator()),
            ),
            if (!_isPlaying && _isVisible)
              const Icon(
                Icons.play_circle_filled_rounded,
                size: 80,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
