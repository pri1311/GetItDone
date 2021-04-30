import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getitdone/screens/authScreen.dart';
import 'package:getitdone/screens/login.dart';
import 'package:getitdone/screens/newProject.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;
  String username, useremail;

  var todos = [
    {
      "task": "Website Design",
      "description":
          "What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting",
      "status": "doing",
      "project": "Crunch chat website",
      "deadline": "April 27",
    },
    {
      "task": "Flutter authentication bug",
      "description":
          "What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting",
      "status": "todo",
      "project": "Productivity app",
      "deadline": "May 27",
    },
    {
      "task": "code review",
      "description":
          "What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting",
      "status": "todo",
      "project": "Crunch chat website",
      "deadline": "May 1",
    },
  ];

  gettodos() {
    FirebaseFirestore.instance
        .collection('project')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['team'].contains(useremail)) {
          var tasks = doc['Tasks'];
          for (var t in tasks) {
            if (t['assigned'].contains(useremail)) {
              setState(() {
                todos.add({
                  'task': t['name'],
                  'status': t['status'],
                  'deadline': t['deadline'],
                  'description': t['description'],
                  'project': doc['name'],
                });
              });
            }
          }
        }
      });
    });
  }

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        useremail = user.email;
        username = user.displayName;
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
    this.gettodos();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("GetItDone!"),
          backgroundColor: Color(0xFF45a4b3),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => newProject(),
                  ),
                );
              },
              color: Colors.white,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: !isloggedin
                  ? CircularProgressIndicator()
                  : Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 0.4 * size.height,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFF45a4b3),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(40.0),
                                  bottomLeft: Radius.circular(40.0),
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(15),
                                height: 0.3 * size.height,
                                width: double.infinity,
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('project')
                                        .snapshots(),
                                    builder: (context, snapshots) {
                                      return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshots.data.docs.length,
                                          itemBuilder: (context, index) {
                                            if (snapshots
                                                .data.docs[index]['team']
                                                .contains(useremail)) {
                                              return Container(
                                                  height: 0.3 * size.height,
                                                  width: 0.4 * size.height,
                                                  margin: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          snapshots.data
                                                                  .docs[index]
                                                              ['name'],
                                                        ),
                                                        Text(
                                                          snapshots.data
                                                                  .docs[index]
                                                              ['description'],
                                                          softWrap: true,
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                            }
                                          });
                                    })),
                          ],
                        ),
                        SizedBox(
                          height: 0.05 * size.height,
                        ),
                        Text(
                          "MY TASKS",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          height: 0.6 * size.height,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('project')
                                .snapshots(),
                            builder: (context, snapshots) {
                              return ListView.builder(
                                itemCount: snapshots.data.docs.length,
                                itemBuilder: (context, index) {
                                  if (snapshots.data.docs[index]['team']
                                      .contains(useremail)) {
                                    var tasks =
                                        snapshots.data.docs[index]['Tasks'];
                                    for (var t in tasks) {
                                      if (t['assigned'].contains(useremail)) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[300],
                                                blurRadius: 5.0,
                                                offset: Offset(
                                                  5,
                                                  5, // Move to bottom 10 Vertically
                                                ),
                                              ),
                                            ],
                                            color: Colors.white,
                                          ),
                                          height: 0.15 * size.height,
                                          margin: EdgeInsets.only(bottom: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                t['name'],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.1,
                                                  color: Color(0xFF24245b),
                                                ),
                                              ),
                                              Text(
                                                snapshots.data.docs[index]
                                                    ['name'],
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 0.02 * size.height,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  t['status'] == "doing"
                                                      ? Container(
                                                          padding:
                                                              EdgeInsets.all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFF17c3b2),
                                                          ),
                                                          child: Text(
                                                              "Inprogress"),
                                                        )
                                                      : Container(
                                                          padding:
                                                              EdgeInsets.all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFfe6d73),
                                                          ),
                                                          child: Text("ToDo"),
                                                        ),
                                                  Text(
                                                    t['deadline'],
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                          onPressed: signOut,
                          child: Text('Signout',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        SizedBox(
                          height: 0.05 * size.height,
                        ),
                      ],
                    ),
            ),
          ),
        ));
  }
}
