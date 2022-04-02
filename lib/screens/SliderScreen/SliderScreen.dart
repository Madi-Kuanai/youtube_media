import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

import '../../Consts.dart';
import '../../backend/PreferenceService.dart';
import '../HomeScreen/HomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var _code;
    return Container(
      child: OnBoardingSlider(
        pageBackgroundColor: Colors.black87,
        totalPage: 2,
        background: [
          Container(
            child: Image.asset(Consts.imagePath + "Hello.png",
                width: size.width * 0.8, height: size.height * 0.5),
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          ),
          Container(
            child: Image.asset(
              Consts.imagePath + "Local.png",
              width: size.width,
              height: size.height * 0.3,
            ),
            margin: EdgeInsets.only(
                left: size.width * 0.05,
                right: size.width * 0.05,
                top: size.height * 0.15),
          ),
        ],
        pageBodies: [
          Container(
            margin: EdgeInsets.only(bottom: size.height * 0.2),
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Welcome to YouTubeMedia",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Poppins-Regular.ttf",
                      color: Colors.white54,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.025),
                  child: SizedBox(
                    width: size.width,
                    child: const Text(
                      "With this app you can watch or download audio track and videos from YouTube",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins-Regular.ttf",
                          color: Colors.white38),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: size.height * 0.25),
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.01),
                  child: SizedBox(
                    width: size.width,
                    child: const Text(
                      "Select the country whose trend you want to see",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins-Regular.ttf",
                          color: Colors.white38),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.01),
                  child: CountryListPick(
                    pickerBuilder: ((
                      context,
                      countryCode,
                    ) =>
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                countryCode!.flagUri.toString(),
                                package: 'country_list_pick',
                                height: size.height * 0.05,
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(left: size.width * 0.05),
                                child: Text(
                                  countryCode.name.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              )
                            ])),
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
                    onChanged: (countryCode) {
                      setState(() {
                        _code = countryCode;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
        headerBackgroundColor: Colors.black87,
        speed: 1.8,
        finishButtonColor: Colors.indigoAccent,
        finishButtonText: "Finish",
        onFinish: () {
          PreferenceService.setLastLocal(_code);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        },
      ),
    );
  }
}
