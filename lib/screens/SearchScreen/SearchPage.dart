import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_media/Consts.dart';
import 'package:youtube_media/backend/SearchVideo.dart';
import 'package:youtube_media/backend/models/VideoModel.dart';

import '../../components/Scrolls.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isDownload = false;
  Widget body = Container(
    color: Colors.black54,
  );
  late AppBar _appBar;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    _appBar = buildAppBar(width, height);
    return Scaffold(
      appBar: _appBar,
      backgroundColor: const Color(0xff141213),
      body: body,
      resizeToAvoidBottomInset: false,
    );
  }

  AppBar buildAppBar(width, height) {
    var textField = TextEditingController();
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
        margin: EdgeInsets.symmetric(vertical: height * 0.1),
        padding: EdgeInsets.only(left: width * 0.025),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 25,
                  color: const Color(0x0fffffff).withOpacity(0.2))
            ]),
        child: RawKeyboardListener(
            focusNode: FocusNode(),
            child: TextField(
              controller: textField,
              textAlignVertical: TextAlignVertical.center,
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
                      onSearch(textField, width, height);
                    },
                  )),
            ), onKey: (event){
              if (event.isKeyPressed(LogicalKeyboardKey.enter)){
                onSearch(textField, width, height);
              }
        },),
      ),
    );
  }

  void onSearch(TextEditingController textField, width, height) async {
    print("OnSearch");
    if (textField.text.isEmpty) return;
    setState(() {
      body =Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        color: const Color(
          0xff222222,
        ),
        child: Lottie.asset("${Consts.lottiePath}loading_animation.json", width: width * 0.3, height: height * 0.2),
      );
    });
    List<VideoModel> searchList = [];
    await SearchApi()
        .getSearchResultList(textField.text.toString())
        .then((value) {
      searchList = value;
    });
    setState(() {
      textField.text = textField.text.toString();
      body = SizedBox(
          width: width,
          height: height,
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) =>
                  GetCard(width, height, searchList.elementAt(index)),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                    height: 1,
                    color: Color(0xff141213),
                  ),
              itemCount: searchList.length));
    });
  }
}
