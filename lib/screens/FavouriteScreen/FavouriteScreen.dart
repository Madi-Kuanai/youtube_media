/*
* {Madi Kuanai}
*/
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_media/backend/PreferenceService.dart';
import 'package:youtube_media/backend/GetOnlyOneVideoInfo.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';

import '../../consts.dart';
import '../../components/getVideoCards.dart';

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
      width: _width,
      height: _height,
      alignment: Alignment.topCenter,
      color: const Color(0xff1a1819),
      child: !isEmpty
          ? SizedBox(
              width: _width,
              height: _height,
              child: RefreshIndicator(
                  backgroundColor: Colors.black54,
                  color: Colors.white,
                  onRefresh: getVideoModels,
                  child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) =>
                          Dismissible(
                              key: UniqueKey(),
                              onDismissed: (DismissDirection direction) {
                                deleteFavourite(ytList![index].getId);
                              },
                              direction: DismissDirection.endToStart,
                              background: Container(
                                  alignment: Alignment.centerRight,
                                  color: Colors.white12,
                                  child: Container(
                                    child: Icon(
                                      Icons.delete_outline,
                                      size: _width * 0.1,
                                    ),
                                    margin:
                                        EdgeInsets.only(right: _width * 0.05),
                                  )),
                              child: GetCard(_width, _height, ytList![index])),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                            height: 1,
                            color: Color(0xff141213),
                          ),
                      itemCount: ytList!.length)))
          : isDownloading
              ? buildLoadingContainer(_width, _height)
              : Container(
                  color: Colors.black12,
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
                        const Icon(
                          Icons.bookmark_border,
                          color: Colors.white12,
                        )
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

  void deleteFavourite(String id) async {
    await PreferenceService.deleteFavourite(id);
  }

  Future<void> getVideoModels() async {
    List<VideoModel>? lst = [];
    for (String key in PreferenceService.getFavourites()) {
      if (key != "TrendLocal") {
        await GetYouTubeInfo.getData(key).then((value) => {lst.add(value)});
      }
    }
    if (mounted) {
      setState(() {
        ytList = lst;
        isEmpty = lst.isEmpty;
        isDownloading = false;
      });
    }
  }
}
