import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:youtube_media/backend/PreferenceService.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../consts.dart';
import '../../backend/Downloader.dart';
import 'package:clipboard/clipboard.dart';

class VideoPlayerPage extends StatefulWidget {
  final _id;
  final _description;
  final bool? _isFavourite;
  final _fullTitle;
  final _publishedTime;
  final _publishedDate;

  VideoPlayerPage(this._id, this._description, this._isFavourite,
      this._fullTitle, this._publishedDate, this._publishedTime,
      {Key? key})
      : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState(_id,
      _description, _isFavourite, _fullTitle, _publishedTime, _publishedDate);
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  final String _id;
  final String _description;
  final _publishedTime;
  final _publishedDate;
  late var _fullTitle;
  bool isExpanded = false;
  bool? _isFavourite;

  late double _width;
  late double _height;
  late YoutubePlayerController youtubePlayerController;

  _VideoPlayerPageState(this._id, this._description, this._isFavourite,
      this._fullTitle, this._publishedTime, this._publishedDate) {
    _isFavourite ??= PreferenceService.checkFavourite(_id);
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: youtubePlayerController,
        progressColors: const ProgressBarColors(
            playedColor: Colors.red, backgroundColor: Colors.white12),
        topActions: [
          Container(
            width: _width * 0.96,
            alignment: Alignment.topRight,
            child: PopupMenuButton(
                icon: Icon(Icons.adaptive.more, color: Colors.white, size: 20),
                color: const Color(0xff211F1D),
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text("Download video",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                      const PopupMenuItem(
                        child: Text("Download music",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ]),
          )
        ],
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
                Divider(
                  height: _height * 0.025,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ExpansionPanelList(
                        children: [
                          ExpansionPanel(
                              backgroundColor: const Color(0xff141213),
                              canTapOnHeader: true,
                              headerBuilder: (context, isExpanded) => Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: _width * 0.025,
                                      vertical: _height * 0.0055),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: _width * 0.9,
                                        child: Text(_fullTitle,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: _height * 0.01, bottom: _height * 0.01),
                                        child: Text(
                                          "Published At: " +
                                              _publishedDate +
                                              ",    " +
                                              _publishedTime,
                                          style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 14),
                                        ),
                                      )
                                    ],
                                  )),
                              body: Container(
                                margin: EdgeInsets.all(_width * 0.025),
                                child: Text(
                                  _description,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ),
                              isExpanded: isExpanded),
                        ],
                        expansionCallback: (int item, bool status) {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                      ),
                      Divider(
                        height: _height * 0.025,
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              bottom: _height * 0.025, left: _width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    deleteAddFromFavourite();
                                  },
                                  icon: Icon(
                                    !_isFavourite!
                                        ? Icons.bookmark_border
                                        : Icons.bookmark,
                                    size: _width * 0.075,
                                    color: Colors.white54,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    FlutterClipboard.copy(
                                        "https://www.youtube.com/watch?v=" +
                                            youtubePlayerController
                                                .metadata.videoId);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "The video link has been copied")));
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    size: _width * 0.075,
                                    color: Colors.white54,
                                  )),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.only(top: _height * 0.005),
                                  width: _width * 0.1,
                                  child: GestureDetector(
                                    onTap: () {
                                      downloadVideo(
                                          "https://www.youtube.com/watch?v=" +
                                              youtubePlayerController
                                                  .metadata.videoId,
                                          youtubePlayerController
                                              .metadata.title);
                                    },
                                    child: Image.asset(
                                      Consts.imagePath + "VideoDownload.png",
                                      fit: BoxFit.cover,
                                      color: Colors.white54,
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.only(top: _height * 0.005),
                                  width: _width * 0.1,
                                  child: GestureDetector(
                                    onTap: () {
                                      downloadMp3();
                                    },
                                    child: Image.asset(
                                      Consts.imagePath + "MusicDownload.png",
                                      fit: BoxFit.cover,
                                      color: Colors.white54,
                                    ),
                                  )),
                            ],
                          )),
                    ],
                  ),
                ))
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
            autoPlay: true,
            enableCaption: false,
            isLive: false,
            controlsVisibleAtStart: true,
            hideControls: false));
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
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              "Download video",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            content: const Text("Do you want to download an video ?"),
            actions: [
              CupertinoDialogAction(
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              CupertinoDialogAction(
                child: const Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        }).then((value) async => {
          if (value == true)
            {
              if (await Downloader.downloadVideo(videoLink, title)
                      .then((value) => value.toString()) !=
                  "Downloading...")
                {
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
                                    margin:
                                        EdgeInsets.only(top: _height * 0.01),
                                    child: const Text(
                                      "There is an error somewhere, please check the storage or internet connection",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
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
                                  onPressed: () =>
                                      Navigator.pop(context, false))
                            ],
                          )))
                }
            }
        });
  }

  void deleteAddFromFavourite() async {
    _isFavourite!
        ? {PreferenceService.deleteFavourite(_id)}
        : {await PreferenceService.addFavourite(_id)};
    setState(() {
      _isFavourite = !_isFavourite!;
    });
  }

  Future<void> downloadMp3() async {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              "Download audio",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            content: const Text(
                "Do you want to download an audio track of a video ?"),
            actions: [
              CupertinoDialogAction(
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              CupertinoDialogAction(
                child: const Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        }).then((value) async => {
          if (value == true)
            {
              await Downloader.downloadMp3(
                      _id, youtubePlayerController.metadata.title)
                  .then((value) => {})
            }
        });
  }
}
