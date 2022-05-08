/*
* {Madi Kuanai}
*/
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_media/Consts.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';
import 'package:youtube_media/backend/PreferenceService.dart';

class SearchApi {
  static var yt = YoutubeAPI(Consts.Api_key, maxResults: 20, type: "video");
  var ytExplode = YoutubeExplode();

  Future<List<VideoModel>> getSearchResultList(String query) async {
    List<YouTubeVideo> tempResult = await yt.search(query, type: "video");

    List<VideoModel> result = [];
    for (YouTubeVideo element in tempResult) {
      var _id = element.id.toString();
      var _description = element.description.toString();
      var _imageLink = element.thumbnail.medium.url;
      var _channelImgLink =
          (await ytExplode.channels.get(element.channelId)).toString();
      var _time = element.duration.toString();
      var _title = element.title;
      var _videoLink = element.url;
      var _channelName = element.channelTitle;
      var _isFavourite = PreferenceService.checkFavourite(_id);
      result.add(VideoModel(
          _id,
          _channelImgLink,
          _imageLink!,
          _title.toString().length > 23
              ? _title.toString().substring(0, 23) + "..."
              : _title,
          _title,
          _time,
          _videoLink,
          _channelName,
          _description,
          _isFavourite));
    }
    return result;
  }

  /* Func for get YouTube trends for local */
  Future<List<VideoModel>> getTrends(String local) async {
    List<VideoModel> result = [];
    List<YouTubeVideo> tempResult = await yt.getTrends(
      regionCode: local,
    );
    for (YouTubeVideo element in tempResult) {
      var _id = element.id.toString();
      var _description = element.description.toString();
      var _imageLink = element.thumbnail.medium.url;
      var _channelImgLink =
          (await ytExplode.channels.get(element.channelId)).logoUrl.toString();
      var _time = element.duration.toString();
      var _title = element.title;
      var _videoLink = element.url;
      var _channelName = element.channelTitle;
      var _isFavourite = PreferenceService.checkFavourite(_id);
      print("TITLE: " + _title);
      result.add(VideoModel(
          _id,
          _channelImgLink,
          _imageLink!,
          _title.toString().length > 25
              ? _title.toString().substring(0, 22) + "..."
              : _title,
          _title.toString(),
          _time.toString(),
          _videoLink,
          _channelName,
          _description,
          _isFavourite));
    }

    return result;
  }
}
