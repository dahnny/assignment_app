import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  File _pickedImage;

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text('Choose picture'),
          content: new Text('Get picture from camera or gallery'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("From Camera"),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(true);
              },
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(false);
              },
              child: Text('From gallery'),
            )
          ],
        );
      },
    );
  }

  void _pickImage(bool val) async {
    var pickedUserImage;
    if (val) {
      pickedUserImage =
//    the image quality is to reduce the image quality by half
          await ImagePicker.pickImage(
              source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    } else {
      pickedUserImage =
//    the image quality is to reduce the image quality by half
          await ImagePicker.pickImage(
              source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    }
    setState(() {
      _pickedImage = pickedUserImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 120,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _pickedImage == null
                        ? AssetImage('assets/images/emoji.jpeg')
                        : FileImage(_pickedImage),
                  ),
                ),
                Positioned(
                  top: 135,
                  left: 170,
                  child: FlatButton.icon(
//                    color: Theme.of(context).accentColor,
                    icon: Icon(
                      Icons.camera_alt,
                      size: 30,
                    ),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    label: Text(''),
                    onPressed: () {
                      _showDialog();
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 30,),
            ListTile(title: Text('Username'), subtitle: Text('username'),),
            ListTile(title: Text('Email'), subtitle: Text('username'),)
          ],
        ),
      ),
    );
  }
}
