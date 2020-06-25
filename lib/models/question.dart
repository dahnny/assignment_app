import 'dart:io';

import 'package:flutter/cupertino.dart';

class Question {
  final String title;
  final String id;
  final String image;
  final String questionText;
  final String username;

  Question({
    @required this.id,
    @required this.title,
    this.image,
    this.questionText,
    this.username,
  });
}
