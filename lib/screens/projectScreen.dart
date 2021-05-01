import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class projectScreen extends StatefulWidget {
  var project;
  projectScreen(this.project);

  @override
  _projectScreenState createState() => _projectScreenState(project);
}

class _projectScreenState extends State<projectScreen> {
  var project;

  _projectScreenState(this.project);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          project['name'],
        ),
        backgroundColor: Color(0xFF45a4b3),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 0.6 * size.height,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('project')
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.hasData) {
                    return ListView.builder(
                        itemCount: snapshots.data.docs.length,
                        itemBuilder: (context, index) {
                          if (snapshots.data.docs[index]['name'] ==
                              project['name']) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount:
                                  snapshots.data.docs[index]['Tasks'].length,
                              itemBuilder: (context, index2) {
                                print(index2);
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
                                        snapshots.data.docs[index]['Tasks']
                                            [index2]['name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.1,
                                          color: Color(0xFF24245b),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 0.02 * size.height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          snapshots.data.docs[index]['Tasks']
                                                      [index2]['status'] ==
                                                  "doing"
                                              ? Container(
                                                  padding: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    color: Colors.yellow,
                                                  ),
                                                  child: Text("Inprogress"),
                                                )
                                              : snapshots.data.docs[index]
                                                              ['Tasks'][index2]
                                                          ['status'] ==
                                                      "todo"
                                                  ? Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFfe6d73),
                                                      ),
                                                      child: Text("ToDo"),
                                                    )
                                                  : Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF17c3b2),
                                                      ),
                                                      child: Text("Done"),
                                                    ),
                                          Text(
                                            snapshots.data.docs[index]['Tasks']
                                                [index2]['deadline'],
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
                            );
                          }
                        });
                  }
                }),
          )
        ],
      ),
    );
  }
}
