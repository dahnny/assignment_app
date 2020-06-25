import 'dart:io';

import 'package:assignment_app/models/answer.dart';
import 'package:assignment_app/models/question.dart';
import 'package:assignment_app/providers/answer_provider.dart';
import 'package:assignment_app/providers/question_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:assignment_app/widgets/pick_image.dart';

class AddQuestionScreen extends StatefulWidget {
  static const routeName = '/add_question';

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  var _check = false;
  String questionId;
  final _form = GlobalKey<FormState>();
  var _question = Question(
    id: DateTime.now().toString(),
    title: '',
    image: null,
    questionText: '',
  );
  var _answer = Answer(
    id: DateTime.now().toString(),
    questionId: '',
    questionText: '',
    answerImage: null,
  );
  File _pickedImage;
  String pickedImageUrl;
  TextEditingController _topicController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => setState(() {
          questionId = ModalRoute.of(context).settings.arguments as String;
        }));
    super.initState();
  }

  void _pickImage() async {
    final pickedQuestionImage =
        await ImagePicker.pickImage(source: ImageSource.camera);
    final user = await FirebaseAuth.instance.currentUser();
    final ref = FirebaseStorage.instance
        .ref()
        .child('question_images')
        .child(Timestamp.now().toString() + '.jpg');
    await ref.putFile(pickedQuestionImage).onComplete;
    pickedImageUrl = await ref.getDownloadURL();

    setState(() {
      _check = false;
      _pickedImage = pickedQuestionImage;
    });
  }

  Widget _textFieldWidget() {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 30),
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.solid),
      ),
      child: Form(
        key: _form,
        child: ListView(children: [
          if (questionId == null)
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a topic';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Topic of assignment',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              onSaved: (value) {
                _question = Question(
                    id: _question.id,
                    title: value,
                    image: _question.image,
                    questionText: _question.questionText,
                    username: _question.username);
              },
            ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a body';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'body',
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 9,
            maxLength: 1000,
            onSaved: (value) {
              if (questionId == null) {
                _question = Question(
                    id: _question.id,
                    title: _question.title,
                    image: _question.image,
                    questionText: value,
                    username: _question.username);
              } else {
                _answer = Answer(
                  id: _answer.id,
                  questionId: questionId,
                  questionText: value,
                  answerImage: _answer.answerImage,
                  username: _answer.username,
                );
              }
            },
          ),
        ]),
      ),
    );
  }

  Future<void> questionForm() async {
    try {
      await Provider.of<QuestionProvider>(context).addQuestion(_question);
    } catch (error) {
      print(error);
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('An error occurred'),
              content: Text('Something went wrong'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    }
    Navigator.of(context).pop();
  }

  void _saveForm() async {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
    if (questionId == null) {
      questionForm();
    } else {
      Provider.of<AnswerProvider>(context).addAnswer(_answer);
      Navigator.of(context).pop();
      print('answer gotten');
    }
  }

  void _saveImage() async {
    if (_topicController.text.isEmpty || _pickedImage == null) {
      return;
    }
    if (questionId == null) {
      _question = Question(
          id: _question.id,
          title: _topicController.text.toString(),
          image: pickedImageUrl,
          questionText: '',
          username: _question.username);
      questionForm();
    } else {
      _answer = Answer(
        id: _answer.id,
        questionId: questionId,
        questionText: '',
        answerImage: pickedImageUrl,
        username: _answer.username,
      );
      print(questionId);
      Provider.of<AnswerProvider>(context).addAnswer(_answer);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
//    final providerData = Provider.of<QuestionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          questionId == null ? 'Submit Question' : 'Submit Answer',
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: [
                  _check ? _textFieldWidget() : PickImage(_pickedImage),
                  if (!_check)
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30),
                      child: TextField(
                        controller: _topicController,
                        decoration: InputDecoration(
                          labelText: 'Topic of Question',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton.icon(
                          label: Text(''),
                          icon: Icon(Icons.image),
                          onPressed: _pickImage,
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
//                  child: Image.asset('assets/images/pen.jpeg'),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        RaisedButton.icon(
                          label: Text(''),
                          icon: Icon(Icons.text_fields),
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            setState(() {
                              _check = true;
                              print('This worked');
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                    child: RaisedButton(
                      onPressed: _check ? _saveForm : _saveImage,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text('Submit Question'),
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
