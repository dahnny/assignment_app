import 'dart:io';

import 'package:flutter/material.dart';

class PickImage extends StatelessWidget {
  File _pickedImage;
  PickImage(this._pickedImage);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 30),
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.solid),
      ),
      child:_pickedImage != null ?
      Image.file(
        _pickedImage,
        fit: BoxFit.cover,
      ):null,
    );
  }
}
