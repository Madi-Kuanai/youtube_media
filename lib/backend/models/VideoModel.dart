/*
* {Madi Kuanai}
*/
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_media/backend/PreferenceService.dart';

class VideoModel {
  final String _id;
  final String _channelImgLink;
  final String _imageUrl;
  final String _title;
  final String _time;
  final String _videoUrl;
  final String _musicUrl;
  final String _channelName;
  final String _description;
  bool _isFavourite;

  VideoModel(
      this._id,
      this._channelImgLink,
      this._imageUrl,
      this._title,
      this._time,
      this._videoUrl,
      this._musicUrl,
      this._channelName,
      this._description,
      this._isFavourite);

  /*-------------------------Getters------------------*/
  String get getId => _id;

  String get getImageUrl => _imageUrl.toString();

  String get getTitle => _title;

  String get getTime => _time;

  bool get getIsFavourite => _isFavourite;

  String get getVideoUrl => _videoUrl;

  String get getMusicUrl => _musicUrl;

  String get getChannelImgLink => _channelImgLink;

  String get getChannelName => _channelName;

  String get getDescription => _description;

  bool get isFavourite {
    /*-- Function to check whether a video is a favorite   --*/
    return FavouritesPreference.checkFavourite(_id);
  }

  Future<void> addFavourite() async {
    /*-- Func to add this video to Favourites*/
    await FavouritesPreference.addFavourite(_id);
  }

  void deleteFavourite() async {
    /*-- Func to delete this video to Favourites*/
    await FavouritesPreference.deleteFavourite(_id);
  }
}
