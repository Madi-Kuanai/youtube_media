import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'Widgets/Body.dart';

class HomePage extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Body(),
      bottomNavigationBar: GNavi(MediaQuery.of(context).size),
    );
  }

  Container GNavi(Size size) {
    return Container(
        height: size.height * 0.08,
        // margin: const EdgeInsets.only(
        //   left: 20,
        //   right: 20,
        // ),
        decoration: const BoxDecoration(
          color: Colors.black87,
          //    borderRadius: BorderRadius.circular(20)
        ),
        child: Flexible(
            child: GNav(
          //rippleColor: Colors.purple.shade300,
          //hoverColor: Colors.purple,
          haptic: true,
          tabBorderRadius: 15,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
          gap: 8,
          color: Colors.black54,
          iconSize: 24,
          tabBackgroundColor: const Color(0xff636DEF),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          tabs: [
            GButton(
              margin: EdgeInsets.only(left: size.width * 0.1),
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 7.5),
              icon: Icons.home_filled,
              text: "Main",
            ),
            GButton(
              margin: EdgeInsets.only(right: size.width * 0.15),
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 7.5),
              icon: Icons.download,
              text: "Downloads",
            ),
          ],
        )));
  }

  AppBar MyAppBar() => AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.download),
            Text(
              "YouTubeMedia",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        centerTitle: true,
      );
}
