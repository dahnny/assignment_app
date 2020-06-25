import 'package:assignment_app/screens/my_answer_screen.dart';
import 'package:assignment_app/screens/my_profile_screen.dart';
import 'package:assignment_app/screens/my_questions_screen.dart';
import 'package:assignment_app/screens/user_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(UserHomeScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My Questions'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(MyQuestionsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.short_text),
            title: Text('My Answers'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(MyAnswerScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.insert_emoticon),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(MyProfileScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
    );
  }
}
