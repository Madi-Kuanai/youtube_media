import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

class Downloader {
  /* This is class for downloading medias from YouTube*/

  static Future<dynamic> downloadVideo(videoLink, videoTitle) async {
    /* Request storage permission */
    Map<Permission, PermissionState> permission =
        await PermissionsPlugin.requestPermissions(
            [Permission.WRITE_EXTERNAL_STORAGE]);
    try {
      /* Download Video */
      await FlutterYoutubeDownloader.downloadVideo(videoLink, videoTitle, 18);
      return "Downloading...";
    } on Exception catch (e) {
      return e;
    }
  }
}
