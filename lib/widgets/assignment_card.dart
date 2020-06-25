import 'package:assignment_app/models/question.dart';
import 'package:assignment_app/screens/question_details.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:assignment_app/providers/question_provider.dart';

class AssignmentCard extends StatefulWidget {
  @override
  _AssignmentCardState createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff021817),
      ),
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 70),
      child: Consumer<QuestionProvider>(
        builder: (context, questionData, _) {
          final questions = questionData.questions;
          return ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                width: 180,
                child: Card(
                  elevation: 7,
                  margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  color: Color(0xfff8fceb),
                  child: InkWell(
                    onTap: () {
                      print('hello');
                      Navigator.of(context).pushNamed(
                        QuestionDetails.routeName,
                        arguments: questions[index].id,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/emoji.jpeg'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              questions[index].title,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: questions.length,
            scrollDirection: Axis.horizontal,
          );
        },
      ),
    );
  }
}
