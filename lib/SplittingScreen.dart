import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class SplittingScreen extends StatefulWidget {
  final String? src;
  final int pageIndex;
  final int? currentPageIndex;
  final bool? isPaused;
  const SplittingScreen({
    Key? key,
    this.src,
    required this.pageIndex,
    this.currentPageIndex,
    this.isPaused,
  }) : super(key: key);

  @override
  _SplittingScreenState createState() => _SplittingScreenState();
}

class _SplittingScreenState extends State<SplittingScreen> {
  /* final List<String> videos = [
    'https://www.graphionicinfotech.com/shorts/1.mp4',
    'https://www.graphionicinfotech.com/shorts/2.mp4',
    'https://www.graphionicinfotech.com/shorts/3.mp4',
    'https://www.graphionicinfotech.com/shorts/4.mp4',
    'https://www.graphionicinfotech.com/shorts/5.mp4',
  ];
*/

  late VideoPlayerController ChallengerVideoPlayerController;
  late VideoPlayerController DueterVideoPlayerController;
  ChewieController? ChallengerChewieController;
  ChewieController? DueterChewieController;
  bool _liked = false;
  bool initialized = false;
  @override
  void initState() {
    super.initState();
    this.initializePlayer();
  }

  Future initializePlayer() async {
    ChallengerVideoPlayerController = VideoPlayerController.network(widget.src!,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ));
    DueterVideoPlayerController = VideoPlayerController.network(widget.src!,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ));

    /*await Future.wait([
      (() async => ChallengerVideoPlayerController.initialize())(),
      (() async => DueterVideoPlayerController.initialize())(),
    ]);*/

    /*Future.wait(
      [
        ChallengerVideoPlayerController.initialize(),
        DueterVideoPlayerController.initialize()
      ],
    );*/
    ChallengerVideoPlayerController.seekTo(Duration(seconds: 2));
    DueterVideoPlayerController.seekTo(Duration(seconds: 2));

    await Future.wait([ChallengerVideoPlayerController.initialize()]);
    await Future.wait([DueterVideoPlayerController.initialize()]);

    ChallengerChewieController = ChewieController(
      videoPlayerController: ChallengerVideoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    DueterChewieController = ChewieController(
      videoPlayerController: DueterVideoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    ChallengerVideoPlayerController.addListener(() {
      // print("VIDEO POSITION (s) ${ChallengerVideoPlayerController.value.position}");
    });

    ChallengerVideoPlayerController.seekTo(Duration.zero);
    DueterVideoPlayerController.seekTo(
        ChallengerVideoPlayerController.value.position);
    DueterVideoPlayerController.setVolume(0.0);

    setState(() {
      ChallengerVideoPlayerController.setLooping(true);
      DueterVideoPlayerController.setLooping(true);
      initialized = true;
    });
  }

  @override
  void dispose() {
    ChallengerVideoPlayerController.dispose();
    ChallengerChewieController!.dispose();
    DueterVideoPlayerController.dispose();
    DueterChewieController!.dispose();
    super.dispose();
  }

  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    if (widget.pageIndex == widget.currentPageIndex &&
        !widget.isPaused! &&
        initialized) {
      ChallengerVideoPlayerController.play();
      // ChallengerVideoPlayerController.pause();
    } else {
      ChallengerVideoPlayerController.pause();
      // ChallengerVideoPlayerController.play();
    }
    if (widget.pageIndex == widget.currentPageIndex &&
        !widget.isPaused! &&
        initialized) {
      DueterVideoPlayerController.play();
      // DueterVideoPlayerController.pause();
    } else {
      DueterVideoPlayerController.pause();
      // DueterVideoPlayerController.play();
    }
    return ChallengerVideoPlayerController.value.isInitialized &&
            DueterVideoPlayerController.value.isInitialized
        ? Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ChallengerChewieController != null &&
                            ChallengerChewieController!
                                .videoPlayerController.value.isInitialized
                        ? SizedBox.expand(
                            child: FittedBox(
                            // fit: BoxFit.fill,
                            fit: BoxFit.contain,
                            child: SizedBox(
                              width: ChallengerVideoPlayerController
                                  .value.size.width
                              /*+MediaQuery.of(context).size.width*/
                              ,
                              height: ChallengerVideoPlayerController
                                  .value.size.height,
                              /* width: 500,
                    height: 500,*/
                              child:
                                  VideoPlayer(ChallengerVideoPlayerController),
                            ),
                          ))
                        : Shimmer.fromColors(
                            baseColor: Colors.grey.shade900,
                            highlightColor: Colors.grey.shade900,
                            direction: ShimmerDirection.ttb,
                            enabled: _enabled,
                            child: Container(
                              color: Colors.grey.shade900,
                              width: ChallengerVideoPlayerController
                                  .value.size.width,
                              height: ChallengerVideoPlayerController
                                  .value.size.height,
                            ),
                          ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DueterChewieController != null &&
                            DueterChewieController!
                                .videoPlayerController.value.isInitialized
                        ? SizedBox.expand(
                            child: FittedBox(
                            // fit: BoxFit.fill,
                            fit: BoxFit.contain,
                            child: SizedBox(
                              width:
                                  DueterVideoPlayerController.value.size.width
                              /*+MediaQuery.of(context).size.width*/
                              ,
                              height:
                                  DueterVideoPlayerController.value.size.height,
                              /* width: 500,
                    height: 500,*/
                              child: VideoPlayer(DueterVideoPlayerController),
                            ),
                          ))
                        : Shimmer.fromColors(
                            baseColor: Colors.grey.shade900,
                            highlightColor: Colors.grey.shade900,
                            direction: ShimmerDirection.ttb,
                            enabled: _enabled,
                            child: Container(
                              color: Colors.grey.shade900,
                              width:
                                  DueterVideoPlayerController.value.size.width,
                              height:
                                  DueterVideoPlayerController.value.size.height,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          )
        : Shimmer.fromColors(
            baseColor: Colors.grey.shade900,
            highlightColor: Colors.grey.shade900,
            direction: ShimmerDirection.ttb,
            enabled: _enabled,
            child: Container(
              color: Colors.grey.shade900,
              width: DueterVideoPlayerController.value.size.width,
              height: DueterVideoPlayerController.value.size.height,
            ),
          );
  }
}
