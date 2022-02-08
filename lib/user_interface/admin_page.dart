import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';

import 'login.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            UserHelper.saveAdmin(snapshot.data!);

            // ignore: non_constant_identifier_names
            var currentUser = FirebaseAuth.instance.currentUser;
            final uid = currentUser!.uid;
            Dashboard.userDashboard(uid);
            Dashboard.usersCount(uid);
          //  var email = currentUser.email;
            return  Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text('Admin Home'),
                leading: IconButton(
                  onPressed: () {
                    AuthHelper.logOut();
                  },
                  icon: const Icon(Icons.logout),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(
                      icon: Icon(Icons.person),
                    ),
                    Tab(
                      icon: Icon(Icons.group),
                    ),
                    Tab(
                      icon: Icon(Icons.dashboard),
                    ),
                    Tab(
                      icon: Icon(Icons.track_changes),
                    ),
                  ],
                ),
              ),
              body: //SingleChildScrollView( child:
              TabBarView(
                controller: _tabController,
                children: <Widget>[
                  SingleChildScrollView(
                child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              // ignore: unused_local_variable

                              var currentUser =
                                  FirebaseAuth.instance.currentUser;
                              var email = currentUser!.email;
                              final docs = snapshot.data!.docs;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document =
                                  snapshot.data!.docs[index];
                                  final users = docs[index].data();
                                 // final userDoc = snapshot.data;
                                //  final userInfo = userDoc;
                                  // ignore: prefer_const_constructors
                                  if ((users as Map<String, dynamic>)['role'] ==
                                      'normalUser') {
                                    return ListTile(
                                      leading: const Icon(Icons.group),

                                      title: Text(document['email']),
                                      subtitle: Text(document['role']),

                                    );
                                  } else if ((users)['role'] == 'admin' &&
                                      (users)['email'] == '$email') {
                                    return ListTile(
                                      leading: const Icon(
                                          Icons.admin_panel_settings),

                                      title: Text(document['email']),
                                      subtitle: Text(document['role']),


                                    );
                                  } else {
                                    return Center(child: Row());
                                  }
                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          child: const Text("Log out"),
                          onPressed: () {
                            AuthHelper.logOut();
                          },
                        )
                      ],
                ),
                    ),

                  SingleChildScrollView(
                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              /*   var currentUser = FirebaseAuth.instance.currentUser;
                      var  email = currentUser!.email;*/
                              final docs = snapshot.data!.docs;
                                // Dashboard.usersCount();
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document =
                                  snapshot.data!.docs[index];
                                  final users = docs[index].data();
                               //   final userDoc = snapshot.data;
                                 // final userInfo = userDoc;
                                  // ignore: prefer_const_constructors
                                  if ((users as Map<String, dynamic>)['role'] ==
                                      'companyUser') {
                                    return ListTile(
                                        leading: const Icon(Icons.group),
                                        title: Text(document['email']),
                                        subtitle: Column(
                                          children: [
                                            Text(document['role']),
                                            const Text(" is "),
                                            Text(
                                              document['companyName'],
                                            ),
                                            const Text(" at "),
                                            Text(document['companyAddress']),
                                            const Text(" Work in "),
                                            Text(document[
                                            'companySpecification']),
                                          ],
                                        ));
                                  } else {
                                    return Center(child: Row());
                                  }
                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          child: const Text("Log out"),
                          onPressed: () {
                            AuthHelper.logOut();
                          },
                        )
                      ],
                    ),
                    ),

                   SingleChildScrollView(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users').doc(uid).collection('Dashboard') //.doc('admin')
                              .snapshots(),

                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                                // var currentUser = FirebaseAuth.instance.currentUser;

                   //   var  email = currentUser!.email;
                              final docs = snapshot.data!.docs;
                         //     Dashboard.usersCount();
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document =
                                  snapshot.data!.docs[index];
                                 // final users = docs[index].data();
                                 // final userDoc = snapshot.data;
                                 // final userInfo = userDoc;
                                  return Column(
                                    children: [
                                      Center(
                                        // height: 400,
                                        // width: 500,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 250,
                                              height: 150,
                                              child: Card(
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'Active Company   ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 15.00,
                                                      ),
                                                    ),
                                                    Text(document['company']),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 250,
                                              height: 150,
                                              child: Card(
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'Active user   ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 15.00,
                                                      ),
                                                    ),
                                                    Text(document['users']),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 250,
                                              height: 150,
                                              child: Card(
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'Active Users this month   ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 15.00,
                                                      ),
                                                    ),
                                                    Text(
                                                        document['activeUser']),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 250,
                                              height: 150,
                                              child: Card(
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'Active Users this day   ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 15.00,
                                                      ),
                                                    ),
                                                    Text(document[
                                                    'todayActiveUser']),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            } else {
                              return const Center(

                                child: Text("well"),
                                //CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    ),

                   SingleChildScrollView(
          child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc('usersTrack')
                              .collection("usersTrack") //.doc()
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              /*   var currentUser = FirebaseAuth.instance.currentUser;
                      var  email = currentUser!.email;*/
                              final docs = snapshot.data!.docs;

                              return ListView.builder(
                               // scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics:  NeverScrollableScrollPhysics(),
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document =
                                  snapshot.data!.docs[index];
                              //    final users = docs[index].data();
                               //   final userDoc = snapshot.data;
                             //     final userInfo = userDoc;

                                  return
                                    ListTile(
                                      title: Column(
                                        children: [

                                           Row(
                                               crossAxisAlignment:
                                               CrossAxisAlignment.start,
                                               children: [
                                                 Text(document['createdBy']),
                                                 const Text(" is "),
                                                 Text(
                                                   document['Action'],
                                                 ),

                                               ]),
                                          Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const Text(" day "),

                                                Text(
                                                  document['day'],
                                                ),
                                                const Text(" time "),

                                                Text(
                                                  document['time'],
                                                ),
                                                const Text(" month "),

                                                Text(
                                                  document['month'],
                                                ),
                                              ]),


                                         ],
                                      ),



                                      );




                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
           // ),
            );
          } else {
            return LoginPage();
          }
        });
  }
}
