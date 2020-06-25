import 'dart:io';

import 'package:flutter/foundation.dart';

class Answer {
  final String id;
  final String questionId;
  final String questionText;
  final String answerImage;
  final String username;


  Answer({
    @required this.id,
    @required this.questionId,
    this.questionText,
    this.answerImage,
    this.username,
  });
}
