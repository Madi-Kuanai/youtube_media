/*
* {Madi Kuanai}
*/

import 'package:flutter/material.dart';
import 'package:youtube_media/backend/PreferenceService.dart';
import 'package:youtube_media/screens/HomeScreen/HomePage.dart';
import 'package:youtube_media/screens/SplashScreen/SplashScreen.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceService.init();
  runApp(Phoenix(child:
      MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? isCodeExist = PreferenceService.getLastLocal();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isCodeExist != null ? HomePage() : const SplashScreen(),
    );
  }
}
