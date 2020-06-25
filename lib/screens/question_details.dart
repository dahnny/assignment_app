import 'package:assignment_app/providers/question_provider.dart';
import 'package:assignment_app/screens/add_question_screen.dart';
import 'package:assignment_app/widgets/app_drawer.dart';
import 'package:assignment_app/widgets/question_details_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionDetails extends StatelessWidget {
  static const routeName = '/question-details';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final question =
        Provider.of<QuestionProvider>(context).findQuestionById(id);
    final check = question.image == null;
    bool isAnswer = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          QuestionDetailHeader(question.id, question.title, question.username),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 10,
              ),
//              height: 200,
              child: check
                  ? Text(question.questionText)
                  : Image.network(
                      question.image,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddQuestionScreen.routeName,
                  arguments: id,
                );
              },
              child: Text(
                'Answer Question',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          )
        ],
      ),
    );
  }
}
