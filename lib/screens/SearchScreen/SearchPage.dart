import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_media/consts.dart';
import 'package:youtube_media/backend/SearchVideo.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/getVideoCards.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isDownload = false, _isError = false;
  Widget body = Container(
    color: Colors.black54,
  );
  late AppBar _appBar;
  var textField = TextEditingController();
  String mainOrder = "relevance";
  String mainVideoDuration = "any";
  double? width;
  double? height;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    _appBar = buildAppBar(width, height);
    return Scaffold(
      appBar: _appBar,
      backgroundColor: const Color(0xff141213),
      body: !_isError
          ? body
          : Container(
              alignment: Alignment.center,
              width: width,
              height: height,
              color: const Color(
                0xff222222,
              ),
              child: SvgPicture.asset(
                "${Consts.imagePath}notFound.svg",
                height: height! * 0.3,
                width: width! * 0.4,
              ),
            ),
      resizeToAvoidBottomInset: false,
    );
  }

  AppBar buildAppBar(width, height) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xff141213),
      title: Container(
        // margin: EdgeInsets.symmetric(vertical: height * 0.1),
        margin: EdgeInsets.only(
            top: height * 0.1, bottom: height * 0.1, right: width * 0.001),
        padding: EdgeInsets.only(left: width * 0.015),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 25,
                  color: const Color(0x0fffffff).withOpacity(0.2))
            ]),
        child: TextField(
          textInputAction: TextInputAction.go,
          focusNode: FocusNode(),
          controller: textField,
          textAlignVertical: TextAlignVertical.center,
          onSubmitted: (key) {
            onSearch(textField);
          },
          decoration: InputDecoration(
              hintText: ("Search in YouTube"),
              hintStyle: const TextStyle(color: Colors.black45),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
                onPressed: () {
                  onSearch(textField);
                },
              )),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: width * 0.025),
          child: IconButton(
              onPressed: () {
                showFilter();
              },
              icon: const Icon(CupertinoIcons.slider_horizontal_3)),
        )
      ],
    );
  }

  void onSearch(TextEditingController textField) async {
    if (textField.text.isEmpty) return;
    setState(() {
      body = Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        color: const Color(
          0xff222222,
        ),
        child: Lottie.asset("${Consts.lottiePath}loading_animation.json",
            width: width! * 0.3, height: height! * 0.2),
      );
    });
    List<VideoModel> searchList = [];
    await SearchApi()
        .getSearchResultList(
            textField.text.toString(), mainOrder, mainVideoDuration)
        .then((value) {
      if (value[0].getId == "0") {
        setState(() {
          _isError = true;
          return;
        });
      }
      searchList = value;
    });
    setState(() {
      textField.text = textField.text.toString();
      body = SizedBox(
          width: width,
          height: height,
          child: Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) =>
                      GetCard(width!, height!, searchList.elementAt(index)),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        height: 1,
                        color: Color(0xff141213),
                      ),
                  itemCount: searchList.length)));
    });
  }

  void showFilter() {
    String _order = mainOrder;
    String _duration = mainVideoDuration;
    showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            builder: (context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter stateSetter) =>
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: const Icon(
                                Icons.horizontal_rule,
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.only(left: width! * 0.45),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: height! * 0.025, left: width! * 0.06),
                              child: const Text(
                                "Order by",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      child: buildCustomButton("Date", "date",
                                          _order, 0.3),
                                      onTap: () {
                                        stateSetter(() {
                                          _order = "date";
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      child: buildCustomButton("Rating",
                                          "rating", _order, 0.3),
                                      onTap: () {
                                        stateSetter(() {
                                          _order = "rating";
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      child: buildCustomButton("Relevance",
                                          "relevance", _order, 0.3),
                                      onTap: () {
                                        stateSetter(() {
                                          _order = "relevance";
                                        });
                                        print(_order);
                                      },
                                    ),
                                    GestureDetector(
                                      child: buildCustomButton("View Count",
                                          "viewCount", _order, 0.3),
                                      onTap: () {
                                        stateSetter(() {
                                          _order = "viewCount";
                                        });
                                        print(_order);
                                      },
                                    ),
                                  ],
                                )),
                            Container(
                              margin: EdgeInsets.only(
                                  top: height! * 0.025, left: width! * 0.06),
                              child: const Text(
                                "Video Duration",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      child: buildCustomButton("Any", "any",
                                          _duration, 0.3),
                                      onTap: () {
                                        stateSetter(() {
                                          _duration = "any";
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      child: buildCustomButton("Longer than 20 minutes",
                                          "long", _duration, 0.5),
                                      onTap: () {
                                        stateSetter(() {
                                          _duration = "long";
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      child: buildCustomButton("Between 4 and 20 minutes long",
                                          "medium", _duration, 0.6),
                                      onTap: () {
                                        stateSetter(() {
                                          _duration = "medium";
                                        });
                                        print(_duration);
                                      },
                                    ),
                                    GestureDetector(
                                      child: buildCustomButton("Less than 4 minutes long",
                                          "short", _duration, 0.5),
                                      onTap: () {
                                        stateSetter(() {
                                          _duration = "short";
                                        });
                                        print(_duration);
                                      },
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ));
            },
            backgroundColor: const Color(0xff25252D))
        .whenComplete(() {
      setState(() {
        mainOrder = _order;
        mainVideoDuration = _duration;
      });
    });
  }

  Container buildCustomButton(String title, String order, String tempOrder, double tempWidth) {
    return Container(
      width: width! * tempWidth,
      height: height! * 0.1,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
          top: height! * 0.04, left: width! * 0.05, bottom: height! * 0.02),
      decoration: BoxDecoration(
        color: Color(order != tempOrder ? 0xff333239 : 0xff7858FE),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
