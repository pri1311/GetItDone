import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:getitdone/components/roundedbutton.dart';
import 'package:getitdone/components/textdetails.dart';
import 'package:getitdone/screens/authScreen.dart';
import 'package:getitdone/screens/homePage.dart';

class newProject extends StatefulWidget {
  @override
  _newProjectState createState() => _newProjectState();
}

class _newProjectState extends State<newProject> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name, description, username, useremail;
  List<String> team, friends;
  bool newuser;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

//function to validate and save user form
  Future<void> _savingData() async {
    final validation = _form.currentState.validate();
    if (!validation) {
      return;
    }
    _form.currentState.save();
  }

  CollectionReference project =
      FirebaseFirestore.instance.collection('project');
  Future<void> createProject() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
    }
    FirebaseFirestore.instance
        .collection('user')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['name'] == username) {
          friends = doc['friendlist'];
        }
        for (String t in team) {
          if (!friends.contains(t)) {}
        }
      });
    });
    // List<String> self = [useremail];
    // return project.add({
    //   'name': name,
    //   'description': description,
    //   'team': self + team,
    //   'admin': useremail,
    // }).then((value) => print("User Added"));
  }

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => authPage(),
          ),
        );
      } else {
        useremail = user.email;
        username = user.displayName;
      }
    });
  }

  @override
  void initState() {
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
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
                  Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: TextDetails(
                            text: 'Project name',
                            onSaved: (String value) {
                              name = value;
                              print(name);
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
                          text: 'Description',
                          onSaved: (String value) {
                            description = value;
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextDetails(
                          text: 'Team',
                          onSaved: (String value) {
                            team = value.split(' ');
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  RoundedButton(
                    colour: Color(0xFF4fbbcc),
                    title: 'Create Project',
                    onPressed: createProject,
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
