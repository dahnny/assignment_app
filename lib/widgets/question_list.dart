import 'package:assignment_app/models/answer.dart';
import 'package:assignment_app/screens/answer_detail_screen.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class QuestionList extends StatelessWidget {
  final Answer answer;

  QuestionList(this.answer);

  dynamic convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    print(todayDate);
    return (formatDate(todayDate, [yyyy, '/', mm, '/', dd]));
  }

  @override
  Widget build(BuildContext context) {
    final answerId = answer.id;
    final questionId = answer.questionId;
    final answerImage = answer.answerImage;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: answerImage != null
            ? NetworkImage(answerImage)
            : AssetImage('assets/images/text_plain.png'),
      ),
      title:
          Text('created at: ${convertDateFromString(questionId).toString()}'),
      subtitle: Text(' Answer By ${answer.username}'),
      trailing: Icon(
        Icons.keyboard_arrow_right,
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AnswerDetailScreen(
             questionId: questionId,
              answerId: answerId,
              answers: null,
            ),
          ),
        );
      },
    );
  }
}
