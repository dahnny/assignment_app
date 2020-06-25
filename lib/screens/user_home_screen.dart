import 'package:assignment_app/providers/question_provider.dart';
import 'package:assignment_app/screens/add_question_screen.dart';
import 'package:assignment_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:assignment_app/widgets/assignment_card.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      if (_isInit) {
        setState(() {
          _isLoading = true;
        });
        Provider.of<QuestionProvider>(context).fetchQuestions().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
      _isInit = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddQuestionScreen.routeName);
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Top Earners',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.center,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87)),
                    height: 150,
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Submit Assignment'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(child: AssignmentCard())
                ],
              ));
  }
}
