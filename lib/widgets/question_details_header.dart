import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionDetailHeader extends StatefulWidget {
  final String id;
  final String title;
  final String username;

  QuestionDetailHeader(this.id, this.title, this.username);

  @override
  _QuestionDetailHeaderState createState() => _QuestionDetailHeaderState();
}

class _QuestionDetailHeaderState extends State<QuestionDetailHeader> {
  var user;
  var userData;

  Future<void> func() async {
    user = await FirebaseAuth.instance.currentUser();
    userData =
        await Firestore.instance.collection('users').document(user.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.id;
    final title = widget.title;
    final username = widget.username;
    return FutureBuilder(
        future: func(),
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            height: 170,
            color: Color(0xff021817),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15),
                  margin: EdgeInsets.only(left: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset('assets/images/emoji.jpeg'),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 25, top: 40),
                    child: Column(
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        snapshot.connectionState == ConnectionState.waiting
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                'By $username',
                                style: TextStyle(color: Colors.white),
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
