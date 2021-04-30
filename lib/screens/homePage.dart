import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getitdone/screens/authScreen.dart';
import 'package:getitdone/screens/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;

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

  var projects = [
    {
      "name": "Crunch Website",
      "description":
          "What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting",
      "deadline": "April 27",
    },
    {
      "name": "Crunch Website",
      "description":
          "What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting",
      "deadline": "April 27",
    },
    {
      "name": "Crunch Website",
      "description":
          "What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting",
      "deadline": "April 27",
    },
  ];

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
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
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("GetItDone!"),
          backgroundColor: Color(0xFF45a4b3),
          elevation: 0,
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
                              margin: EdgeInsets.all(15),
                              height: 0.3 * size.height,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: projects.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      height: 0.3 * size.height,
                                      width: 0.4 * size.height,
                                      margin: EdgeInsets.all(10),
                                      color: Colors.white.withOpacity(0.5),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(
                                              projects[index]['name'],
                                            ),
                                            Text(
                                              projects[index]['description'],
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                              ),
                            ),
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
                          child: ListView.builder(
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
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
                                        5, 5, // Move to bottom 10 Vertically
                                      ),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                height: 0.15 * size.height,
                                margin: EdgeInsets.only(bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      todos[index]['task'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.1,
                                        color: Color(0xFF24245b),
                                      ),
                                    ),
                                    Text(
                                      todos[index]['project'],
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        todos[index]['status'] == "doing"
                                            ? Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF17c3b2),
                                                ),
                                                child: Text("Inprogress"),
                                              )
                                            : Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFfe6d73),
                                                ),
                                                child: Text("ToDo"),
                                              ),
                                        Text(
                                          todos[index]['deadline'],
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
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
