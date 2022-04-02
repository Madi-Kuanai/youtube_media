/*
* {Madi Kuanai}
*/
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_media/backend/PreferenceService.dart';
import 'package:youtube_media/backend/GetOneVideoInfo.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';

import '../../Consts.dart';
import '../../components/Scrolls.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  var ytList;
  bool isEmpty = true;
  bool isDownloading = true;

  @override
  void initState() {
    super.initState();
    getVideoModels();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    return Container(
      height: _height,
      alignment: Alignment.topCenter,
      color: const Color(0xff141213),
      child: !isEmpty
          ? SizedBox(
              width: _width,
              height: _height,
              child: RefreshIndicator(
                  onRefresh: getVideoModels,
                  child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) =>
                          GetCard(_width, _height, ytList![index]),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                            height: 1,
                            color: Color(0xff141213),
                          ),
                      itemCount: ytList!.length)))
          : isDownloading
              ? buildLoadingContainer(_width, _height)
              : Container(
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "${Consts.imagePath}favourite.png",
                          width: _width * 0.5,
                        ),
                        Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: _height * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: _width * 0.7,
                                  child: const Text(
                                    "Here you will see the saved videos, add your favorite videos by clicking on",
                                    style: TextStyle(
                                        color: Colors.white12, fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )),
                        const Icon(Icons.bookmark_border)
                      ])),
    );
  }

  Container buildLoadingContainer(double _width, double _height) {
    return Container(
      alignment: Alignment.center,
      width: _width,
      height: _height,
      color: const Color(
        0xff222222,
      ),
      child: Lottie.asset("${Consts.lottiePath}loading_animation.json",
          width: _width * 0.3, height: _height * 0.2),
    );
  }

  Future<Null> getVideoModels() async {
    List<VideoModel>? lst = [];
    for (String key in FavouritesPreference.getFavourites()) {
      print(key);
      await GetYouTubeInfo.getData(key).then((value) => {lst.add(value)});
    }
    setState(() {
      ytList = lst;
      isEmpty = lst.isEmpty;
      isDownloading = false;
    });
  }
}
