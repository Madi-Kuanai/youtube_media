/*
* {Madi Kuanai}
*/
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';

import 'PreferenceService.dart';

class GetYouTubeInfo {
  static var yt;
  static Video? video;
  static var channel;
  static var _imageLink;
  static var _duration;
  static var _title;
  static var _videoLink;
  static var _channelImgLink;
  static String? _channelName;
  static String? _description;
  static var _idVideo;
  static var _isFavourite;
  static var _publishedDate;
  static var _publishedTime;

  static Future<VideoModel> getData(_id) async {
    yt = YoutubeExplode();
    video = await yt.videos.get(_id);
    channel = await yt.channels.getByVideo(_id);
    _imageLink = video!.thumbnails.standardResUrl;
    _duration = _getDuration(Duration(seconds: video!.duration!.inSeconds)
        .toString()
        .split(".")[0]
        .toString()
        .split(":"));

    _title = video!.title;
    _videoLink = video!.url;
    _channelImgLink = channel.logoUrl;
    _channelName = channel.title;
    _description = video!.description.toString();
    _idVideo = video!.id.toString();
    _isFavourite = PreferenceService.checkFavourite(_id);
    _publishedDate = video!.publishDate.toString().split(" ")[0];
    var _tempPublishedTime =
        video!.publishDate.toString().split(" ")[1].split(".")[0];
    _publishedTime =
        _tempPublishedTime.substring(0, _tempPublishedTime.lastIndexOf(":"));
    return VideoModel(
        _idVideo,
        _channelImgLink,
        _imageLink,
        _title.toString().length > 25
            ? _title.toString().substring(0, 22) + "..."
            : _title,
        _title,
        _duration,
        _videoLink,
        _channelName!,
        _description!,
        _isFavourite,
        _publishedDate,
        _publishedTime);
  }

  @override
  String toString() {
    return "Title: $_title \n Description: $_description \n id: $_idVideo Favourite: $_isFavourite";
  }

  static _getDuration(duration) {
    return duration[0] == "0"
        ? duration.sublist(1).join(":")
        : duration.join(":");
  }
}
