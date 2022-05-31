/*
* {Madi Kuanai}
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:restart_app/restart_app.dart';
import 'package:youtube_media/backend/PreferenceService.dart';
import 'package:youtube_media/components/getVideoCards.dart';
import '../../../consts.dart';

import '../../../backend/SearchVideo.dart';
import '../../../enums.dart';

class Body extends StatefulWidget {
  var _code;

  Body(this._code);

  @override
  State<StatefulWidget> createState() => BodyState(_code);
}

class BodyState extends State<Body> {
  static var ytList;
  bool isDownload = false, isTrendError = false, isInternetError = false;
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
    return ytList != null && isInternetError == false
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
        : isInternetError
            ? Container(
                alignment: Alignment.center,
                width: _width,
                height: _height,
                color: const Color(
                  0xff222222,
                ),
                child: SvgPicture.asset(
                  "${Consts.imagePath}notFound.svg",
                  height: _height * 0.3,
                  width: _width * 0.4,
                ),
              )
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
          showCustomDialog(
              "Error of the selected location",
              "Sorry, but YouTube does not support the trend of the selected country. Change the selected location or set the automatic location (USA)",
              Errors.NullTrend);
          return;
        } else if (video[0].getId == "1") {
          showCustomDialog(
              "Internet connection error",
              "Check your internet connection and try restarting the app",
              Errors.InternetConnectionError);
          return;
        }
      }
      if (mounted) {
        setState(() {
          ytList = video;
        });
      }
    });
  }

  void showCustomDialog(String title, String desc, Errors error) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Theme(
              data: ThemeData.dark(),
              child: CupertinoAlertDialog(
                title: FittedBox(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                content: Text(
                  desc,
                  style: TextStyle(
                      fontSize:
                          error == Errors.InternetConnectionError ? 14 : 12),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              ));
        }).then((value) => {
          if (error == Errors.NullTrend)
            {
              if (value == true)
                {PreferenceService.setLastLocal("US"), Restart.restartApp()}
            }
          else if (error == Errors.InternetConnectionError)
            {
              setState(() {
                isInternetError = true;
              })
            }
        });
  }
}
