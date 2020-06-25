import 'package:assignment_app/providers/answer_provider.dart';
import 'package:assignment_app/providers/question_provider.dart';
import 'package:assignment_app/screens/answer_detail_screen.dart';
import 'package:assignment_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyQuestionsScreen extends StatefulWidget {
  static const routeName = '/my-questions';

  @override
  _MyQuestionsScreenState createState() => _MyQuestionsScreenState();
}

class _MyQuestionsScreenState extends State<MyQuestionsScreen> {
  var _init = true;
  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      if (_init) {
        setState(() {
          _isLoading = true;
        });

        Provider.of<QuestionProvider>(context).fetchQuestions(true).then(
              (_) => setState(() {
                _isLoading = false;
              }),
            );
      }
      _init = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final questions = Provider.of<QuestionProvider>(context).questions;
    final answersData = Provider.of<AnswerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Questions'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                answersData.fetchAnswersByQuestionId(questions[index].id);
                final answers = answersData.answers;
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('Title: ${questions[index].title}'),
                      subtitle:
                          Text('${answers.length.toString()} have submitted'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AnswerDetailScreen(
                              questionId: questions[index].id,
                              answers: answers,
                              answerId: null,
                            ),
                          ),
                        );
                      },
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    Divider()
                  ],
                );
              },
              itemCount: questions.length,
            ),
    );
  }
}
