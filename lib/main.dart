/*
* {Madi Kuanai}
*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_media/backend/PreferenceService.dart';
import 'package:youtube_media/screens/HomeScreen/HomePage.dart';

import 'Consts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavouritesPreference.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
