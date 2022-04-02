/*
* {Madi Kuanai}
*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_media/backend/PreferenceService.dart';
import 'package:youtube_media/screens/HomeScreen/HomePage.dart';
import 'package:youtube_media/screens/SliderScreen/SliderScreen.dart';

import 'Consts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? isCodeExist = PreferenceService.getLastLocal();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isCodeExist != null ? HomePage() : SplashScreen(),
    );
  }
}
