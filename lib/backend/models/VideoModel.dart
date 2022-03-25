class VideoModel {
  final String _channelImgLink;
  final String _imageUrl;
  final String _title;
  final String _time;
  final String _videoUrl;
  final String _musicUrl;
  final String _channelName;
  final String _description;

  VideoModel(this._channelImgLink, this._imageUrl, this._title, this._time,
      this._videoUrl, this._musicUrl, this._channelName, this._description);

  String get getImageUrl => _imageUrl.toString();

  String get getTitle => _title;

  String get getTime => _time;

  String get getVideoUrl => _videoUrl;

  String get getMusicUrl => _musicUrl;

  String get getChannelImgLink => _channelImgLink;

  String get getChannelName => _channelName;

  String get getDescription => _description;
}
