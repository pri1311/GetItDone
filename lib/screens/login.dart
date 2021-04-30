import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:getitdone/components/roundedbutton.dart';
import 'package:getitdone/components/textdetails.dart';
import 'package:getitdone/screens/authScreen.dart';
import 'package:getitdone/screens/homePage.dart';
import 'package:getitdone/screens/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String password, email;
  bool newuser;
  int otp;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    });
  }

  login() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        showError(e.message);
        print(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  void initState() {
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => authPage()));
      },
      child: Container(
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  SizedBox(
                    height: 100,
                    child: TypewriterAnimatedTextKit(
                      isRepeatingAnimation: false,
                      speed: Duration(milliseconds: 150),
                      text: ["Hello there.\nWelcome back!"],
                      textStyle: TextStyle(
                        fontSize: 40.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: TextDetails(
                            text: 'Email Address',
                            onSaved: (String value) {
                              email = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Cannot Be Empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        TextDetails(
                          text: 'Password',
                          val: true,
                          onSaved: (String value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter New Password";
                            }
                            if (value.length < 8) {
                              return "Password must be at least 8 characters long";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forgot your Password?',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  RoundedButton(
                    colour: Color(0xFF4fbbcc),
                    title: 'Log In',
                    onPressed: login,
                  ),
                  RoundedButton(
                    colour: Color(0xFF3b8c99),
                    title: "Don't have an account?"
                        " Sign up instead",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Registeration()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
