import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';
import 'package:luqiaapp/user_interface/setting.dart';

import 'login.dart';

class CompanyUserPage extends StatefulWidget {
  const CompanyUserPage({Key? key}) : super(key: key);

  @override
  _CompanyUserPageState createState() => _CompanyUserPageState();
}

class _CompanyUserPageState extends State<CompanyUserPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {

            var currentUser = FirebaseAuth.instance.currentUser;

            final uid = currentUser?.uid;
            var name = currentUser?.displayName;

            Dashboard.userDashboard(uid!);

            UserHelper.saveUserCompany(currentUser);
            return Scaffold(
              appBar: AppBar(
                title:
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome'.tr,
                        style: const TextStyle(
                            color: Colors.black,
                            //  fontWeight: ,
                            // fontFamily: titleFontFamily,
                            fontSize: 25.0),
                      ),
                      Text('    $name'),
                    ]),
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Setting()),
                    );
                  },
                  icon: const Icon(Icons.settings),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout'.tr,
                    onPressed: () {
                      AuthHelper.logOut();
                    },
                  ),
                ],
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(
                      icon: Icon(Icons.cloud_outlined),
                    ),
                    Tab(
                      icon: Icon(Icons.beach_access_sharp),
                    ),
                    Tab(
                      icon: Icon(Icons.brightness_5_sharp),
                    ),
                  ],
                ),
              ),
              body: TabBarView(controller: _tabController, children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .collection('userInfo')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          //   final docs = snapshot.data!.docs;

                          if (snapshot.hasData && snapshot.data != null) {
                            final docs = snapshot.data!.docs;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: docs.length,
                              itemBuilder: (BuildContext context, int index) {
                               // final user = docs[index].data();
                              //  DocumentSnapshot document = snapshot.data!.docs[index];
                               // var companyName = document['companyName'];
                                // ignore: prefer_const_constructors
                                return ListTile(
                                    title: const Text('welcom company user')
                                    // title: Text(user['name'] ?? user['email']),
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
                const Center(
                  child: Text("It's cloudy here"),
                ),
                const Center(
                  child: Text("It's rainy here"),
                ),
              ]
              ),
            );
          } else {
            return LoginPage();
          }
        });
  }
}

