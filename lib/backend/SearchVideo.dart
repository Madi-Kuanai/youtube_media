import 'dart:convert';

import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_media/Consts.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';

class SearchApi {
  static var yt = YoutubeAPI(Consts.Api_key);
  var channel = YoutubeExplode();

  Future<List<VideoModel>> getSearchResultList(String query) async {
    List<YouTubeVideo> tempResult = await yt.search(query);
    List<VideoModel> result = [];
    for (YouTubeVideo element in tempResult) {
      var _imageLink;
      String _time;
      String _title;
      String _videoLink;
      String _musicLink;
      String _channelImgLink;
      String _channelName;
      String _description;
      _description = element.description.toString();
      _imageLink = element.thumbnail.medium.url;
      _channelImgLink =
          (await channel.channels.get(element.channelId)).toString();
      _time = element.duration.toString();
      _title = element.title;
      _videoLink = element.url;
      _channelName = element.channelTitle;
      _musicLink = "https://vk.com/";
      print("Title: $_title");
      result.add(VideoModel(
          _channelImgLink,
          _imageLink,
          _title.toString().length > 25
              ? _title.toString().substring(0, 27) + "..."
              : _title,
          _time,
          _videoLink,
          _musicLink,
          _channelName,
          _description));
    }
    return result;
  }

  Future<List<VideoModel>> getTrends(String local) async {
    List<VideoModel> result = [];
    List<YouTubeVideo> tempResult = await yt.getTrends(
      regionCode: local,
    );
    for (YouTubeVideo element in tempResult) {
      var _imageLink;
      String? _time;
      String _title;
      String _videoLink;
      String _musicLink;
      var _channelImgLink;
      String _channelName;
      String _description;
      _description = element.description.toString();
      _imageLink = element.thumbnail.medium.url;
      _channelImgLink =
          (await channel.channels.get(element.channelId)).logoUrl.toString();
      _time = element.duration.toString();
      _title = element.title;
      _videoLink = element.url;
      _channelName = element.channelTitle;
      _musicLink = "https://vk.com/";
      result.add(VideoModel(
          _channelImgLink,
          _imageLink,
          _title.toString().length > 25
              ? _title.toString().substring(0, 25) + "..."
              : _title,
          _time.toString(),
          _videoLink,
          _musicLink,
          _channelName,
          _description));}

    return result;
  }
}
