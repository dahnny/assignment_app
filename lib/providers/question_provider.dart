import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:assignment_app/models/question.dart';

class QuestionProvider with ChangeNotifier {
  List<Question> _questions = [

  ];

  List<Question> get questions {
    return [..._questions];
  }

  Future<void> addQuestion(Question question) async {

    try {
      final user = await FirebaseAuth.instance.currentUser();
      final userData =
      await Firestore.instance.collection('users').document(user.uid).get();
      var url;
      String questionText;
      if (question.image != null) {
        url = question.image;
      } else {
        url = null;
      }
      if (question.questionText != null) {
        questionText = question.questionText;
      }

      Firestore.instance.collection('questions').add({
        'userId': user.uid,
        'username': userData['username'],
        'title': question.title,
        'assignmentId': question.id,
        'questionImageUrl': url,
        'questionText': questionText,
      });
      print(userData);
      _questions.add(question);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }


  Question findQuestionById(String id) {
    return _questions.firstWhere((question) => question.id == id);
  }

  Future<void> fetchQuestions([bool filterByUser = false]) async {
    final user = await FirebaseAuth.instance.currentUser();
    final List<Question> loadedQuestion = [];
    var fetchedData;
    if (filterByUser) {
      fetchedData = await Firestore.instance
          .collection('questions')
          .where('userId', isEqualTo: user.uid)
          .getDocuments();
    } else {
      fetchedData =
          await Firestore.instance.collection('questions').getDocuments();
    }
    fetchedData.documents.forEach((question) {
      loadedQuestion.insert(
        0,
        Question(
          id: question.data['assignmentId'],
          title: question.data['title'],
          image: question.data['questionImageUrl'].toString().isEmpty ||
                  question.data['questionImageUrl'] == null
              ? null
              : question.data['questionImageUrl'],
          questionText: question.data['questionText'].toString().isEmpty
              ? ''
              : question.data['questionText'],
          username: question.data['username']
        ),
      );
    });
    _questions = loadedQuestion;
    notifyListeners();
  }
}
