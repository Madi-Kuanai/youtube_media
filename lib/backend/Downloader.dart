/*
* {Kuanai} {Madi}
*/
import 'dart:io';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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

  /* Download mp3 stream with videoId */
  /* Get mp3 link with videoId*/
  static Future<bool> downloadMp3(videoId, title) async {
    Map<Permission, PermissionState> permission =
        await PermissionsPlugin.requestPermissions(
            [Permission.WRITE_EXTERNAL_STORAGE]);
    try {
      var youtube = YoutubeExplode();
      var manifest = await youtube.videos.streamsClient.getManifest(videoId);
      var streamInfo = manifest.audioOnly.withHighestBitrate();
      var stream = youtube.videos.streamsClient.get(streamInfo);
      print("URL: " + streamInfo.url.toString());
      print("URL: " + streamInfo.toString());
      // Open a file for writing.
      Directory? tempDir = await DownloadsPathProvider.downloadsDirectory;
      var filePath = tempDir!.path +
          '/${title.toString().replaceAll(" ", "").replaceFirst("...", "")}' +
          ".mp3";
      var file = File(filePath);
      var fileStream = file.openWrite();

      // Pipe all the content of the stream into the file.
      await stream.pipe(fileStream);

      // Close the file.
      await fileStream.flush();
      await fileStream.close();
      return true;
    } on Exception catch (e) {
      print(e.toString());
      print(e.runtimeType);
      return false;
    }
  }
}
