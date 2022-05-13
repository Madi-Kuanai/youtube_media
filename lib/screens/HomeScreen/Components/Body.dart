/*
* {Madi Kuanai}
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restart_app/restart_app.dart';
import 'package:youtube_media/backend/PreferenceService.dart';
import 'package:youtube_media/components/getVideoCards.dart';
import '../../../Consts.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';

import '../../../backend/SearchThreadVideos.dart';

class Body extends StatefulWidget {
  var _code;

  Body(this._code);

  @override
  State<StatefulWidget> createState() => BodyState(_code);
}

class BodyState extends State<Body> {
  static var ytList;
  bool isDownload = false, isError = false;
  var code;

  BodyState(this.code);

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
    return ytList != null && !isError
        ? SizedBox(
            width: _width,
            height: _height,
            child: RefreshIndicator(
                backgroundColor: Colors.black54,
                color: Colors.white,
                onRefresh: initVideos,
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) =>
                        GetCard(_width, _height, ytList[index]),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          height: 1,
                          color: Color(0xff141213),
                        ),
                    itemCount: ytList.length)),
          )
        : isError
            ? Container()
            : Container(
                alignment: Alignment.center,
                width: _width,
                height: _height,
                color: const Color(
                  0xff222222,
                ),
                child: Lottie.asset(
                    "${Consts.lottiePath}loading_animation.json",
                    width: _width * 0.3,
                    height: _height * 0.2),
              );
  }

  Future<void> initVideos() async {
    await SearchApi().getTrends(code).then((video) {
      if (mounted) {
        if (video[0].getId == "0") {
          showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text(
                    "Error of the selected location",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                      "Sorry, but YouTube does not support the trend of the selected country. Change the selected location or set the automatic location (USA)"),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                );
              }).then((value) => {
                if (value == true)
                  {isError = true, PreferenceService.setLastLocal("US"), Restart.restartApp()}
              });
          return;
        }
      }
      setState(() {
        ytList = video;
      });
    });
  }
}
