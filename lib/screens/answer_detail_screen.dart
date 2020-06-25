import 'package:assignment_app/providers/answer_provider.dart';
import 'package:assignment_app/providers/question_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnswerDetailScreen extends StatelessWidget {
  final String questionId;
  final String answerId;
  final List<dynamic> answers;
  var answer;

//  final String answerText;
//  final String answerImage;

  AnswerDetailScreen({
    @required this.questionId,
    this.answerId,
    this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final question =
        Provider.of<QuestionProvider>(context).findQuestionById(questionId);

    if (answerId != null) {
      answer = Provider.of<AnswerProvider>(context).findAnswerById(answerId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Column(
        crossAxisAlignment:CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(20),
            height: 300,
            child: Text(question.title),
          ),
          if (answerId == null)
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(15),
                      color: Colors.grey,
                      child: Text(
                        answers[index].answerImage != null
                            ? answers[index].answerImage
                            : answers[index].questionText,
                      ),
                    ),
                  );
                },
                itemCount: answers.length,
              ),
            ),
          if (answerId != null)
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(15),
                  color: Colors.grey,
                  child: Text(
                    answer.answerImage != null
                        ? answer.answerImage
                        : answer.questionText,
                  ),
                )
              ],
            )
        ],
      ),
    );
  }
}
