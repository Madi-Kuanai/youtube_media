import 'package:flutter/material.dart';
import 'package:youtube_media/ApiServer/GetApiInfo.dart';
import 'package:youtube_media/ApiServer/videoInfoModel.dart';
import 'package:youtube_media/Consts.dart';

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BodyState();
}

class BodyState extends State<Body> {
  var _ImageLink;
  var _title;
  var _time;
  var channel;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: 3, itemBuilder: (context, item) => VideoCard(context, item));
  }

  Container VideoCard(context, item) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            color: const Color(0xff121414)),
        height: height * 0.4,
        width: width,
        child: Column(
          children: [
            Stack(
              children: [
                FittedBox(
                  child: _ImageLink == null
                      ? Image.asset(
                          Consts.imagePath + "waitBack.jpg",
                        )
                      : Image.network(
                          _ImageLink,
                          width: width,
                        ),
                  fit: BoxFit.fill,
                ),
                Positioned(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      _time ?? "00:00",
                      style: const TextStyle(color: Colors.white),
                    ),
                    color: Colors.black87,
                  ),
                  right: width * 0.01,
                  bottom: height * 0.01,
                )
              ],
            )
          ],
        ));
  }

  void getInfo() {
    var info = GetInfo(id: "Yx9mXnVXWzs");
    info.getData().then((VideoModel model) => setState(() {
          _ImageLink = model.getImageUrl.toString();
          _title = model.getTitle;
          _time = model.getTime;
        }));

    print("OK");
  }
}
