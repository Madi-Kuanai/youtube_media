// @dart=2.9
/*
* {Madi Kuanai}
*/

import 'package:country_list_pick/country_selection_theme.dart';
import 'package:flutter/material.dart';
import 'package:youtube_media/backend/PreferenceService.dart';
import 'package:youtube_media/screens/HomeScreen/HomePage.dart';
import 'package:youtube_media/screens/SplashScreen/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String isCodeExist = PreferenceService.getLastLocal();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isCodeExist != null ? HomePage() : const SplashScreen(),
    );
  }
}
