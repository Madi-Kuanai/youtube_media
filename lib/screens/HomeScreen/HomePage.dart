/*
* {Madi Kuanai}
*/
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:youtube_media/screens/FavouriteScreen/FavouriteScreen.dart';
import 'package:youtube_media/screens/SearchScreen/SearchPage.dart';
import '../../backend/PreferenceService.dart';
import 'Components/Body.dart';
import 'package:country_list_pick/country_list_pick.dart';

class HomePage extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  int _index = 0;
  var _width;
  var _height;

  @override
  void initState() {
    setState(() {
      _index = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setState(() {
      _width = size.width;
      _height = size.height;
    });
    return Scaffold(
      appBar: MyAppBar(),
      body: _index == 0 ? Body() : const FavouritePage(),
      bottomNavigationBar: GNavi(MediaQuery.of(context).size),
      resizeToAvoidBottomInset: false,
    );
  }

  Container GNavi(Size size) {
    return Container(
        height: size.height * 0.08,
        decoration: const BoxDecoration(
          color: Colors.black87,
        ),
        child: Flexible(
            child: GNav(
          tabBorderRadius: 15,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
          gap: 8,
          color: Colors.black54,
          iconSize: size.height * 0.035,
          tabBackgroundColor: const Color(0xff636DEF),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          tabs: [
            GButton(
              margin: EdgeInsets.only(left: size.width * 0.1),
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 7.5),
              icon: Icons.local_fire_department_outlined,
              text: "Trends",
              onPressed: () => setState(() => _index = 0),
            ),
            GButton(
              margin: EdgeInsets.only(right: size.width * 0.15),
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 7.5),
              icon: Icons.bookmark,
              text: "Favorites",
              onPressed: () => setState(() => _index = 1),
            ),
          ],
        )));
  }

  AppBar MyAppBar() => AppBar(
        title: Row(
          children: const [
            Icon(Icons.download),
            Text(
              "YTMedia",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        actions: [
          CountryListPick(
            pickerBuilder: ((
              context,
              countryCode,
            ) =>
                const Icon(
                  Icons.place_outlined,
                  color: Colors.white,
                )),
            useUiOverlay: true,
            useSafeArea: false,
            appBar: AppBar(
              title: const Text(
                "Select the country whose trend you want to see",
                style: TextStyle(fontSize: 14),
              ),
            ),
            theme: CountryTheme(
              isShowFlag: true,
              isShowTitle: true,
              isDownIcon: true,
              showEnglishName: true,
            ),
            onChanged: (countryCode) =>
                {PreferenceService.setLastLocal(countryCode!.code.toString())},
          ),
          Container(
            margin: EdgeInsets.only(right: _width * 0.05),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const SearchPage()));
              },
            ),
          ),
        ],
      );
}
