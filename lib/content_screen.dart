import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class ContentScreen extends StatefulWidget {
  final String? src;
  final int pageIndex;
  final int? currentPageIndex;
  final bool? isPaused;
  const ContentScreen({
    Key? key,
    this.src,
    required this.pageIndex,
    this.currentPageIndex,
    this.isPaused,
  }) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src!,
        videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: false, mixWithOthers: false));
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    setState(() {
      _videoPlayerController.setLooping(true);
      initialized = true;
    });
  }

  @override
  void dispose() {
    print("Dispose 2");
    print(widget.currentPageIndex);
    print(widget.pageIndex);
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  bool _enabled = true;
  @override
  Widget build(BuildContext context) {
    if (widget.pageIndex == widget.currentPageIndex &&
        !widget.isPaused! &&
        initialized) {
      _videoPlayerController.play();
      // _videoPlayerController.pause();
    } else {
      print("Paused");
      _videoPlayerController.pause();
      // _videoPlayerController.play();
    }
    return _videoPlayerController.value.isInitialized
        ? Stack(
            fit: StackFit.expand,
            children: [
              _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? GestureDetector(
                      onTap: () {
                        if (_videoPlayerController.value.volume == 0) {
                          _videoPlayerController.setVolume(1.0);
                        } else {
                          _videoPlayerController.setVolume(0.0);
                        }
                        setState(() {});
                      },
                      onLongPressStart: (_) => _videoPlayerController.pause(),
                      onLongPressEnd: (_) => _videoPlayerController.play(),
                      child: SizedBox.expand(
                          child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoPlayerController.value.size.width ?? 0,
                          height: _videoPlayerController.value.size.height ?? 0,
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      )),
                    )
                  : Shimmer.fromColors(
                      baseColor: Colors.grey.shade900,
                      highlightColor: Colors.grey.shade900,
                      direction: ShimmerDirection.ttb,
                      enabled: _enabled,
                      child: Container(
                        color: Colors.grey.shade900,
                        width: _videoPlayerController.value.size.width ?? 0,
                        height: _videoPlayerController.value.size.height ?? 0,
                      ),
                    ),
            ],
          )
        : SizedBox.expand(
            child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoPlayerController.value.size.width ?? 0,
              height: _videoPlayerController.value.size.height ?? 0,
              child: VideoPlayer(_videoPlayerController),
            ),
          ));
  }
}
