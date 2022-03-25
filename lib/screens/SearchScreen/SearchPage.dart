import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isDownload = false;
  late double width, height;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: const Color(0xff141213),
    );
  }

  AppBar buildAppBar(BuildContext context) {
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
        child: TextField(
          controller: textField,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              hintText: ("Search in YouTube"),
              hintStyle: const TextStyle(
                  color: Colors.black45),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  onSearch(textField);
                },
              )),
        ),
      ),
    );
  }

  void onSearch(TextEditingController textField) {

  }
}
