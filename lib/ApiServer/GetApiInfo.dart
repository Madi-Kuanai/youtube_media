import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_media/ApiServer/videoInfoModel.dart';

class GetInfo {
  var _id;

  GetInfo({required id}) {
    _id = id;
  }

  Future<VideoModel> getData() async {
    var uri = Uri.https("youtube-media-downloader.p.rapidapi.com",
        "/v2/video/details", {"videoId": _id});
    final response = await http.get(uri, headers: {
      'x-rapidapi-host': 'youtube-media-downloader.p.rapidapi.com',
      'x-rapidapi-key': '081aa5aeadmsh0af5e9d63015a69p10d2bcjsna9715e827b74'
    });

    var map = jsonDecode(response.body);
    var _imageLink = map["thumbnails"][4]["url"];
    var _time = Duration(
            days: 0,
            hours: 0,
            minutes: 0,
            milliseconds: map["videos"]["items"][0]["lengthMs"])
        .toString()
        .split(".")[0];
    var _title = map["title"].toString();
    var _videoLink =  map["videos"]["items"][0]["url"];
    var _musicLink = map["audios"]["items"][0]["url"];
    return VideoModel(ImageUrl: _imageLink, musicUrl: _musicLink, time: _time, title: _title, videoUrl: _videoLink);

  }

}
