import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_media/backend/PreferenceService.dart';
import 'package:youtube_media/backend/VideoInfo.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';

import '../../Consts.dart';
import '../../components/Scrolls.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<VideoModel>? ytList;

  @override
  void initState() {
    super.initState();
    getVideoModels();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    return ytList != null
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
        : Container(
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
    });
  }
}
