/*
* {Madi Kuanai}
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_media/backend/Downloader.dart';
import 'package:youtube_media/screens/VideoPlayerScreen/VideoPlayerPage.dart';

import '../backend/models/VideoModel.dart';
import '../Consts.dart';

class GetCard extends StatefulWidget {
  double width;
  double height;
  VideoModel video;

  GetCard(this.width, this.height, this.video, {Key? key}) : super(key: key);

  @override
  State<GetCard> createState() => _GetCardState(width, height, video);
}

class _GetCardState extends State<GetCard> {
  var _id;
  var width;
  var height;
  var _ImageLink;
  var _title;
  var _time;
  var _channelImg;
  var _videoLink;
  var _channelName;
  var video;
  var _isFavourite;
  var _description;
  var _fullTitile;

  _GetCardState(this.width, this.height, this.video);

  getInfo() {
    if (mounted) {
      setState(() {
        /* We take the information from the model sent to us */
        _id = video.getId;
        _ImageLink = video.getImageUrl;
        _title = video.getTitle;
        _fullTitile = video.getFullTitle;
        _time = video.getTime;
        _channelName = video.getChannelName;
        _videoLink = video.getVideoUrl;
        _channelImg = video.getChannelImgLink;
        _isFavourite = video.isFavourite;
        _description = video.getDescription;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            color: const Color(0xff141213)),
        height: height * 0.45,
        width: width,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VideoPlayerPage(_id, _description, _isFavourite, _fullTitile)),
            );
          },
          child: Column(
            children: [
              Stack(
                children: [
                  FittedBox(
                    child: _ImageLink == null
                        ? Image.asset(
                            Consts.imagePath + "waitBack.jpg",
                          )
                        : Image.network(
                            _ImageLink,
                            width: width,
                            height: height * 0.35,
                            fit: BoxFit.contain,
                          ),
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black87,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        _time ?? "00:00",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    right: width * 0.01,
                    bottom: height * 0.01,
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  left: width * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: height * 0.02),
                        child: CircleAvatar(
                          backgroundColor: const Color(0xff999999),
                          radius: 20,
                          backgroundImage: NetworkImage(_channelImg),
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: width * 0.65,
                            padding: EdgeInsets.only(right: width * 0.05),
                            margin: EdgeInsets.only(
                                left: width * 0.03, top: height * 0.02),
                            child: Flex(direction: Axis.horizontal, children: [
                              Text(
                                _title ?? "Load...",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                              )
                            ])),
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.03, top: height * 0.005),
                          child: Text(
                            _channelName ?? "",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white54),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                        width: width * 0.05,
                        height: height * 0.05,
                        child: GestureDetector(
                          child: _isFavourite
                              ? const Icon(
                                  Icons.bookmark,
                                  color: Colors.white10,
                                )
                              : const Icon(Icons.bookmark_border,
                                  color: Colors.white10),
                          //_isFavourite ? CustomCheckBox(_isFavourite) : CustomCheckBox(_isFavourite),
                          onTap: () {
                            setState(() {
                              addDeleteFavourite();
                              _isFavourite = !_isFavourite;
                            });
                          },
                        )),

                    /* Create option menu */
                    Container(
                        margin: EdgeInsets.only(left: width * 0.02),
                        child: PopupMenuButton(
                            icon: Icon(Icons.adaptive.more,
                                color: Colors.white, size: 20),
                            color: const Color(0xff211F1D),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text(
                                      "Music Download",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () => {downloadMp3()},
                                    value: 1,
                                  ),
                                  PopupMenuItem(
                                    child: const Text("Video Download",
                                        style: TextStyle(color: Colors.white)),
                                    onTap: () => {downloadVideo(_videoLink, _title)},
                                    value: 2,
                                  )
                                ]))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future<void> downloadVideo(videoLink, title) async {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
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

  void addDeleteFavourite() async {
    !_isFavourite ? await video.addFavourite() : await video.deleteFavourite();
  }

  Future<void> downloadMp3() async {
    await Downloader.downloadMp3(_id, _title).then((value) => {});
  }
}
