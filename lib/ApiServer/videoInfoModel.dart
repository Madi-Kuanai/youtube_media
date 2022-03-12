class VideoModel {
  var ImageUrl;
  var title;
  var time;
  var videoUrl;
  var musicUrl;

  VideoModel(
      {this.ImageUrl, this.title, this.musicUrl, this.time, this.videoUrl});

  String get getImageUrl {
    return ImageUrl.toString();
  }

  String get getTitle {
    return title;
  }

  String get getTime {
    return time;
  }

  String get getVideoUrl {
    return videoUrl;
  }

  String get getMusicUrl {
    return musicUrl;
  }
}
