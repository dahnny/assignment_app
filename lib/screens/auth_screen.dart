import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';
  final _auth = FirebaseAuth.instance;
  AuthResult authResult;

  void _submitForm(BuildContext ctx) async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    try {
      if (_isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (err) {
      String message = 'Please enter correct credentials';

      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context);
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  child: Image.asset(
                    'assets/images/flutter_image.jpeg',
                    fit: BoxFit.fill,
                  ),
                  height: deviceSize.size.height / 2,
                  width: 700,
                  margin: EdgeInsets.only(bottom: 12),
                ),
                Positioned(
                  top: (deviceSize.size.height / 2) - 50,
                  left: 70,
                  child: Container(
                      child: Text(
                    _isLogin ? 'Sign In' : 'Sign Up',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 40,
                    ),
                  )),
                ),
              ],
              overflow: Overflow.visible,
            ),
            Form(
              key: _formKey,
//            autovalidate: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (!_isLogin)
                      Container(
                        margin: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                        width: deviceSize.size.width - 70,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty || value.length < 4) {
                              return 'Please enter a longer username';
                            }
                            return null;
                          },
                          autovalidate: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffe5e5e5),
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.black87),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                          onSaved: (value) {
                            username = value;
                          },
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      width: deviceSize.size.width - 70,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffe5e5e5),
                          hintText: 'Email Address',
                          hintStyle: TextStyle(color: Colors.black87),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          email = value;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, top: 10),
                      width: deviceSize.size.width - 70,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'Please enter a longer password';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffe5e5e5),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.black87),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Create an account'
                            : 'Already have an account',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(right: 20, bottom: 12),
                child: ButtonTheme(
                  buttonColor: Color(0xff141414),
                  minWidth: 120,
                  child: RaisedButton(
                    onPressed: () {
                      _submitForm(context);
                    },
                    child: Text(_isLogin ? 'Sign In' : 'Sign Up'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
