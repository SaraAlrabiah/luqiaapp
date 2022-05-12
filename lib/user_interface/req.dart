// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';
import 'package:luqiaapp/operation/group_operation.dart';
import 'package:luqiaapp/operation/location_operation.dart';
import 'package:luqiaapp/user_interface/setting.dart';
import 'package:provider/provider.dart';
import 'add_user.dart';
import 'login.dart';

class ReqPage extends StatefulWidget {
  const ReqPage({Key? key, required uid}) : super(key: key);

  @override
  _ReqPageState createState() => _ReqPageState();
}

class _ReqPageState extends State<ReqPage> with TickerProviderStateMixin {
  late TabController _tabController;

  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Provider.of<LocationProvider>(context, listen: false).initialization();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var currentUser = FirebaseAuth.instance.currentUser;
            UserHelper.saveUser(currentUser);
            final uid = currentUser!.uid;
            var email = currentUser.email;
            Dashboard.userDashboard(uid,email! );


            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.white,
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Request'.tr,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0),
                      ),

                    ]),
                leading: IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.arrow_back_ios),
                  tooltip: 'Back',
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  SettingPage(uid: uid)),
                    );
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.add),
                    tooltip: 'Add',
                    onPressed:  (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  AddUserPage(uid: uid,)),
                        );

                      },


                  ),
                ],
                bottom: TabBar(
                  indicatorColor:  Color.fromRGBO(	83, 83, 83, 1),
                  labelColor: Color.fromRGBO(	83, 83, 83, 1),
                  controller: _tabController,
                  tabs:  <Widget>[
                    Tab(text: 'Following Request', icon: Icon(Icons.person_add , color: Colors.black,)),
                    Tab(text: 'Group Request', icon: Icon(Icons.group_add , color: Colors.black,)),

                  ],
                ),
              ),
              body: TabBarView(

                controller: _tabController,
                children: <Widget>[

                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(uid)
                              .collection("Req")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final docs = snapshot.data!.docs;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document =
                                  snapshot.data!.docs[index];
                                  //final users = docs[index].data();
                                  //  final userDoc = snapshot.data;
                                  // ignore: prefer_const_constructors
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return ListTile(
                                      leading: const Icon(Icons.person),

                                      title: Text(document['email']),
                                      // subtitle: Text(document['role'])  ,
                                      trailing: IconButton(
                                        icon: const Icon(Icons.check_box),
                                        tooltip: 'accept this user',
                                        onPressed: () async {
                                          final uid = currentUser.uid;
                                          //  Dashboard.userDashboard(uid);
                                          // Dashboard.userDashboard(uid);
                                          final currentEmail =
                                              currentUser.email;
                                          final documentId = document.id;
                                          final foId =
                                          document['id']; // problem here
                                          final foEmail = document['email'];
                                          UserHelper.userAccept(uid, foId,
                                              currentEmail!, foEmail);

                                          UserHelper.delete(uid, documentId);
                                        },
                                      ),
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

                      ],
                    ),
                  ),

                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .collection("GroupReq") //.doc()
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final docs = snapshot.data!.docs;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document =
                                  snapshot.data!.docs[index];
                                  // final users = docs[index].data();
                                  //  final userDoc = snapshot.data;
                                  // final userInfo = userDoc;
                                  // ignore: prefer_const_constructors

                                  return ListTile(
                                    leading: const Icon(Icons.group),
                                    title: Column(children: [
                                      Row(children: [
                                        const Text('Group Name      '),
                                        Text(document['GroupName']),
                                      ]),
                                    ]),
                                    subtitle: Column(
                                      children: [
                                        Row(children: [
                                          const Text("Group Activity      "),
                                          Text(document['GroupActivity']),
                                        ]),
                                        Row(children: [
                                          const Text("Created By      "),
                                          Text(document['CreateByEmail']),
                                        ]),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.check_box),
                                      tooltip: 'accept this group',
                                      onPressed: () async {
                                        final uid = currentUser.uid;
                                        final currentUserEmail =
                                            currentUser.email;
                                        final groupId = document['groupId'];
                                        final groupName = document['GroupName'];
                                        final groupActivity =
                                        document['GroupActivity'];
                                        final createdByEmail =
                                        document['CreateByEmail'];
                                        final createdById =
                                        document['CreateById'];
                                        final documentId = document.id;
                                        GroupOperation.addNewUser(
                                            createdById,
                                            createdByEmail!,
                                            groupId,
                                            groupName,
                                            groupActivity,
                                            uid,
                                            currentUserEmail!);
                                        GroupOperation.deleteGroupReq(
                                            uid, documentId);
                                        GroupOperation.addGroupMember(
                                            groupId, uid, currentUserEmail);
                                      },
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
                        // ignore: deprecated_member_use
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return LoginPage();
          }
        });
  }
}
