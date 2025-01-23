import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SavedVideoPlayerScreen extends StatefulWidget {
  final String videoUrl; // The URL of the video to play

  const SavedVideoPlayerScreen({super.key, required this.videoUrl});

  @override
  _SavedVideoPlayerScreenState createState() => _SavedVideoPlayerScreenState();
}

class _SavedVideoPlayerScreenState extends State<SavedVideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Video'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
