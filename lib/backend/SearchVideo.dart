/*
* {Madi Kuanai}
*/
import 'dart:io';

import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_media/consts.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';
import 'package:youtube_media/backend/PreferenceService.dart';

class SearchApi {
  static var yt = YoutubeAPI(Consts.Api_key, maxResults: 30, type: "video");
  var ytExplode = YoutubeExplode();

  Future<List<VideoModel>> getSearchResultList(
      String query, String order, videoDuration) async {
    List<VideoModel> result = [];
    try {
      List<YouTubeVideo> tempResult = await yt.search(query,
          type: "video", order: order, videoDuration: videoDuration);
      for (YouTubeVideo element in tempResult) {
        var _id = element.id.toString();

        var _description = element.description.toString();
        var _imageLink = element.thumbnail.medium.url;
        var _channelImgLink =
            (await ytExplode.channels.get(element.channelId)).toString();
        var _duration = element.duration.toString();
        var _title = element.title;
        var _videoLink = element.url;
        var _channelName = element.channelTitle;
        var _isFavourite = PreferenceService.checkFavourite(_id);
        //2022-05-25T00:13:16Z
        var _publishedDate = element.publishedAt
            ?.substring(0, element.publishedAt?.indexOf("T"));
        var _publishedTime = element.publishedAt?.substring(
            element.publishedAt!.indexOf("T"),
            element.publishedAt?.indexOf("Z"));
        result.add(VideoModel(
            _id,
            _channelImgLink,
            _imageLink!,
            _title.toString().length > 23
                ? _title.toString().substring(0, 23) + "..."
                : _title,
            _title,
            _duration,
            _videoLink,
            _channelName,
            _description,
            _isFavourite,
            _publishedDate!,
            _publishedTime!));
      }
    } catch (ex) {
      print("Ex: " + ex.toString());
      if (ex.runtimeType != SocketException) {
        result.add(VideoModel(
            "0", "", "", "", "0", "0", "0", "0", "0", false, "", ""));
      } else {
        result.add(VideoModel(
            "1", "", "", "", "0", "0", "0", "0", "0", false, "", ""));
      }
    }
    return result;
  }

  /* Func for get YouTube trends for local */
  Future<List<VideoModel>> getTrends(String local) async {
    List<VideoModel> result = [];
    try {
      List<YouTubeVideo> tempResult = await yt.getTrends(
        regionCode: local,
      );

      for (YouTubeVideo element in tempResult) {
        var _id = element.id.toString();
        var _description = element.description.toString();
        var _imageLink = element.thumbnail.medium.url;
        var _channelImgLink = (await ytExplode.channels.get(element.channelId))
            .logoUrl
            .toString();
        var _duration = element.duration.toString();
        var _title = element.title;
        var _videoLink = element.url;
        var _channelName = element.channelTitle;
        var _isFavourite = PreferenceService.checkFavourite(_id);
        var _publishedDate = element.publishedAt
            ?.substring(0, element.publishedAt?.indexOf("T"));
        String? _publishedTime = element.publishedAt?.substring(
            element.publishedAt!.indexOf("T") + 1,
            element.publishedAt!.indexOf("Z") - 3);
        result.add(VideoModel(
            _id,
            _channelImgLink,
            _imageLink!,
            _title.toString().length > 25
                ? _title.toString().substring(0, 22) + "..."
                : _title,
            _title.toString(),
            _duration.toString(),
            _videoLink,
            _channelName,
            _description,
            _isFavourite,
            _publishedDate!,
            _publishedTime!));
      }
    } catch (ex) {
      print("Ex: " + ex.toString());
      if (ex.runtimeType != SocketException) {
        result.add(VideoModel(
            "0", "", "", "", "0", "0", "0", "0", "0", false, "", ""));
      } else {
        result.add(VideoModel(
            "1", "", "", "", "0", "0", "0", "0", "0", false, "", ""));
      }
    }
    return result;
  }
}
