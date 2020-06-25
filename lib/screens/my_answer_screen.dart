import 'package:assignment_app/providers/answer_provider.dart';
import 'package:assignment_app/providers/question_provider.dart';
import 'package:assignment_app/widgets/app_drawer.dart';
import 'package:assignment_app/widgets/question_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAnswerScreen extends StatelessWidget {
  static const routeName = '/answer-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Answers'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<AnswerProvider>(context, listen: false).fetchAnswersById(),
          builder: (context, snapshot) {
            final answers = Provider.of<AnswerProvider>(context).answers;

            return snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return QuestionList(answers[index]);
                    },
                    itemCount: answers.length,
                  );
          }),
    );
  }
}
