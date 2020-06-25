import 'package:assignment_app/providers/answer_provider.dart';
import 'package:assignment_app/providers/question_provider.dart';
import 'package:assignment_app/screens/add_question_screen.dart';
import 'package:assignment_app/screens/auth_screen.dart';
import 'package:assignment_app/screens/my_answer_screen.dart';
import 'package:assignment_app/screens/my_profile_screen.dart';
import 'package:assignment_app/screens/my_questions_screen.dart';
import 'package:assignment_app/screens/question_details.dart';
import 'package:assignment_app/screens/user_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: QuestionProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AnswerProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          AddQuestionScreen.routeName: (context) => AddQuestionScreen(),
          QuestionDetails.routeName: (context) => QuestionDetails(),
          MyQuestionsScreen.routeName: (context)=> MyQuestionsScreen(),
          UserHomeScreen.routeName: (context)=> UserHomeScreen(),
          MyAnswerScreen.routeName: (context)=> MyAnswerScreen(),
          MyProfileScreen.routeName: (context)=> MyProfileScreen()
        },
        home: StreamBuilder<Object>(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return UserHomeScreen();
              }
              return AuthScreen();
            }),
      ),
    );
  }
}
