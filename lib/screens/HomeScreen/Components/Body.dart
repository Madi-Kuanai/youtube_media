import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_media/screens/HomeScreen/Components/Scrolls.dart';
import '../../../Consts.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';

import '../../../backend/SearchVideo.dart';


class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BodyState();
}

class BodyState extends State<Body> {
  var ytList;
  bool isDownload = false;

  @override
  void initState() {
    initVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var _width = size.width;
    var _height = size.height;
    return ytList != null
        ? SizedBox(
            width: _width,
            height: _height,
            child: ListView.separated(
                itemBuilder: (BuildContext context, int index) =>
                    GetCard(_width, _height, ytList[index]),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      height: 1,
                      color: Color(0xff141213),
                    ),
                itemCount: ytList.length))
        : Container(
      alignment: Alignment.center,
            width: _width,
            height: _height,
            color: const Color(
              0xff222222,
            ),
            child: Lottie.asset("${Consts.lottiePath}loading_animation.json", width: _width * 0.3, height: _height * 0.2),
          );
  }

  void initVideos() async {
    await SearchApi().getTrends("RU").then((video) {
      setState(() {
        ytList = video;
      });
    });
  }
}
