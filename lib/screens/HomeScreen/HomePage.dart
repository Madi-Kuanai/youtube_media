/*
* {Madi Kuanai}
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:restart_app/restart_app.dart';
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
  var _code;

  @override
  void initState() {
    setState(() {
      _code = PreferenceService.getLastLocal();
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
      appBar: myAppBar(),
      body: _index == 0 ? Body(_code) : const FavouritePage(),
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
        ));
  }

  AppBar myAppBar() => AppBar(
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
            initialSelection: _code,
            useUiOverlay: true,
            useSafeArea: false,
            appBar: AppBar(
              title: const Text(
                "Select the country whose trend you want to see",
                style: TextStyle(fontSize: 14),
              ),
            ),
            pickerBuilder: ((
              context,
              countryCode,
            ) =>
                const Icon(
                  Icons.place_outlined,
                  color: Colors.white,
                )),
            theme: CountryTheme(
              isShowFlag: true,
              isShowTitle: true,
              isDownIcon: true,
              isShowCode: true,
              initialSelection: _code,
              alphabetSelectedBackgroundColor: Colors.black12,
              showEnglishName: true,
              lastPickText: "Last county is: " + _code,
            ),
            onChanged: (countryCode) {
              if (PreferenceService.getLastLocal() != countryCode?.code){

              PreferenceService.setLastLocal(countryCode!.code.toString());
              setState(() {
                _code = countryCode.code.toString();
              });
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Theme(
                      data: ThemeData.dark(),
                      child: CupertinoAlertDialog(
                        content: SizedBox(
                          // color: const Color(0xff2B2B34),
                          width: _width * 0.7,
                          height: _height * 0.3,
                          child: Column(
                            children: [
                              Icon(
                                Icons.done,
                                size: _width * 0.2,
                                color: const Color(0xff5B89E5),
                              ),
                              const Text("Attention",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Poppins",
                                      color: Colors.white)),
                              Container(
                                margin: EdgeInsets.only(top: _height * 0.01),
                                child: const Text(
                                  "If you have chosen a different country, you need to restart the program",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          CupertinoDialogAction(
                              child: const Text("Skip"),
                              onPressed: () {
                                Navigator.pop(context, false);
                              }),
                          CupertinoDialogAction(
                              child: const Text("Reset"),
                              onPressed: () {
                                Navigator.pop(context, true);
                                Restart.restartApp();
                              })
                        ],
                      ))).then((value) {});}
            },
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
