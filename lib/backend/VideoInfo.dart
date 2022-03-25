import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';

class GetInfo {
  var _id;

  GetInfo({required id}) {
    _id = id;
  }

  Future<VideoModel> getData() async {
    var yt = YoutubeExplode();
    var video = await yt.videos.get(_id);
    var channel = await yt.channels.getByVideo(_id);
    var _imageLink = video.thumbnails.standardResUrl;
    var _time =
        Duration(hours: 0, minutes: 0, seconds: video.duration!.inSeconds)
            .toString();
    var _title = video.title;
    var _videoLink = video.url;
    var _musicLink = "https://vk.com/";
    var _channelImgLink = channel.logoUrl;
    String _channelName = channel.title;
    String _description = video.description.toString();
    return VideoModel(
        _channelImgLink,
        _imageLink,
        _title.toString().length > 25
            ? _title.toString().substring(0, 25) + "..."
            : _title,
        _time,
        _videoLink,
        _musicLink,
        _channelName,
        _description);
  }
}
