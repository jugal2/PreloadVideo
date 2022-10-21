import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:preloadvideo/content_screen.dart';
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PreloadPageController? _pageController;
  int current = 0;
  bool isOnPageTurning = false;

  void scrollListener() {
    if (isOnPageTurning &&
        _pageController!.page == _pageController!.page!.roundToDouble()) {
      setState(() {
        print("isOnPageTuring IF");
        current = _pageController!.page!.toInt();
        isOnPageTurning = false;
      });
    } else if (!isOnPageTurning &&
        current.toDouble() != _pageController!.page) {
      if ((current.toDouble() - _pageController!.page!).abs() > 0.1) {
        setState(() {
          print("isOnPageTuring ELSE");
          isOnPageTurning = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PreloadPageController();
    _pageController!.addListener(scrollListener);
  }

  List<String> videos = [
    'https://www.graphionicinfotech.com/shortsvideos/1.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/2.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/3.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/4.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/6.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/7.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/8.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/9.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/10.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/11.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/12.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/13.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/14.mp4',
    'https://www.graphionicinfotech.com/shortsvideos/15.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PreloadPageView.builder(
        controller: _pageController,
        itemCount: videos.length,
        // onPageChanged: onchahged,
        preloadPagesCount: videos.length,
        pageSnapping: true,

        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // controller: _pageController,
        itemBuilder: (context, index) {
          print("current video index" + index.toString());
          print("current page index" + current.toString());
          return ContentScreen(
            src: videos[index],
            pageIndex: index,
            currentPageIndex: current,
            isPaused: isOnPageTurning,
          );
          /*return VideoPage(
          widget.videos[index],
          pageIndex: index,
          currentPageIndex: current,
          isPaused: isOnPageTurning,
        );*/
        },
      ),
    );
  }

  onchahged(int index) {
    setState(() {
      current = index;
    });
  }
}
