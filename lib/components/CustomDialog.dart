/*
* {Madi Kuanai}
*/
import 'package:flutter/material.dart';

import '../Consts.dart';

class DialogCustom extends StatelessWidget {
  var _title;

  DialogCustom(this._title);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      backgroundColor: const Color(0xff404040),
      child: DialogInfo(context),
    );
  }

  DialogInfo(context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Consts.imagePath + "Ok.png"),
          const Text(
            "Successfully!",
            style: TextStyle(fontFamily: "Poppins", fontSize: 20),
          ),
          const Text("The audio track was uploaded successfully.", textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
