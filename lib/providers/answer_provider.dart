import 'package:assignment_app/models/answer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AnswerProvider with ChangeNotifier {
  List<Answer> _answers = [];

  List<Answer> get answers {
    return [..._answers];
  }

  Answer findAnswerById(String id) {
    return _answers.firstWhere((answer) => answer.id == id);
  }

  void addAnswer(Answer answer) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      final userData =
          await Firestore.instance.collection('users').document(user.uid).get();
      var url;
      String answerText;
      if (answer.answerImage != null) {
        url = answer.answerImage;
      } else {
        url = null;
      }
      if (answer.questionText != null) {
        answerText = answer.questionText;
      }

      Firestore.instance.collection('answers').add({
        'userId': user.uid,
        'answerId': answer.id,
        'questionId': answer.questionId,
        'questionImageUrl': url,
        'questionText': answerText,
        'username': userData['username'],
      });

//      _answers.add(answer);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAnswersByQuestionId(String questionId) async {
    List<Answer> loadedAnswer = [];
    try {
      final fetchedData = await Firestore.instance
          .collection('answers')
          .where('assignmentId', isEqualTo: questionId)
          .getDocuments();
      fetchedData.documents.forEach((answer) {
        loadedAnswer.insert(
          0,
          Answer(
            id: answer['answerId'],
            questionId: answer['questionId'],
            questionText: answer['questionText'],
            answerImage: answer['questionImageUrl'],
            username: answer['username'],
          ),
        );
      });
      _answers = loadedAnswer;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

//  This method fetches answers by current
  Future<void> fetchAnswersById() async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      List<Answer> loadedAnswer = [];
      final fetchedData = await Firestore.instance
          .collection('answers')
          .where('userId', isEqualTo: user.uid)
          .getDocuments();
      fetchedData.documents.forEach((answer) {
        loadedAnswer.insert(
          0,
          Answer(
            id: answer['answerId'],
            questionId: answer['questionId'],
            questionText: answer['questionText'],
            answerImage: answer['questionImageUrl'],
            username: answer['username'],
          ),
        );
      });
      _answers = loadedAnswer;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
