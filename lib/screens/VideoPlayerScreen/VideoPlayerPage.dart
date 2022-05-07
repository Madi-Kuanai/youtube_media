import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../backend/Downloader.dart';

class VideoPlayerPage extends StatefulWidget {
  var _id;

  VideoPlayerPage(this._id);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState(this._id);
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  String _id;
  late double _width;
  late double _height;
  late YoutubePlayerController youtubePlayerController;

  _VideoPlayerPageState(this._id);

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: youtubePlayerController,
        showVideoProgressIndicator: true,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
            colors: const ProgressBarColors(
                bufferedColor: Colors.white12,
                playedColor: Colors.red,
                handleColor: Colors.red),
          ),
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
            onPressed: () {
              downloadVideo(
                  "https://www.youtube.com/watch?v=" +
                      youtubePlayerController.metadata.videoId,
                  youtubePlayerController.metadata.title);
            },
          ),
          FullScreenButton(),
        ],
      ),
      builder: (context, widget) {
        return Scaffold(
          appBar: buildMyAppBar(),
          body: Container(
            color: const Color(0xff141213),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    initYouTubeVideoController();
    super.initState();
  }

  @override
  void deactivate() {
    youtubePlayerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    youtubePlayerController.dispose();
    super.dispose();
  }

  void initYouTubeVideoController() {
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: _id,
        flags: const YoutubePlayerFlags(
            autoPlay: true, enableCaption: false, isLive: false));
  }

  AppBar buildMyAppBar() {
    return AppBar(
      backgroundColor: Colors.black87,
      elevation: 20,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> downloadVideo(videoLink, title) async {
    if (await Downloader.downloadVideo(videoLink, title)
            .then((value) => value.toString()) !=
        "Downloading...") {
      /* If download answer incorrect, we show message about it */
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Theme(
              data: ThemeData.dark(),
              child: CupertinoAlertDialog(
                content: SizedBox(
                  // color: const Color(0xff2B2B34),
                  width: _width * 0.7,
                  height: _height * 0.3,
                  child: Column(
                    children: [
                      Icon(
                        Icons.close,
                        size: _width * 0.2,
                        color: const Color(0xff5B89E5),
                      ),
                      const Text("Attention",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Poppins",
                              color: Colors.white)),
                      Container(
                        margin: EdgeInsets.only(top: _height * 0.01),
                        child: const Text(
                          "There is an error somewhere, please check the storage or internet connection",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                      child: const Text("Ok"),
                      onPressed: () => Navigator.pop(context, false))
                ],
              )));
    }
  }
}
