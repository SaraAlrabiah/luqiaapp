// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';
import 'package:luqiaapp/operation/location_operation.dart';
import 'package:luqiaapp/user_interface/group_detail.dart';
import 'package:luqiaapp/user_interface/setting.dart';
import 'package:provider/provider.dart';
import 'group_creation.dart';
import 'group_info.dart';
import 'login.dart';
import 'meeting_creation.dart';
import 'package:luqiaapp/style/button.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required uid}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  late TabController _tabController;

  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

            var name = currentUser.displayName;

            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.white,
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome'.tr,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0),
                      ),
                      Text('    $name',  style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 20.0),
                      ),
                    ]),
                leading: IconButton(
                  color: Colors.black,
                  onPressed: () {
                   Navigator.push( context,MaterialPageRoute(builder: (context) =>    SettingPage(uid: uid,)), );
                  },
                  icon: const Icon(Icons.settings),
                ),
                actions: <Widget>[
                  IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                    onPressed: () {
                      AuthHelper.logOut();
                    },
                  ),
                ],
                bottom: TabBar(
                    indicatorColor:  Color.fromRGBO(	83, 83, 83, 1),
                    labelColor: Color.fromRGBO(	83, 83, 83, 1),
                    controller: _tabController,
                    tabs:  <Widget>[
                Tab(text: 'Dashboard', icon: Icon(Icons.dashboard , color: Colors.black,)),
                Tab(text: 'Groups', icon: Icon(Icons.group , color: Colors.black,)),
                Tab(text: 'Following', icon: Icon(Icons.person , color: Colors.black,)),

              ]
                ),
              ),
              body: TabBarView(

                controller: _tabController,
                children: <Widget>[



                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(uid)
                              .collection('userDashboard') //.doc(uid)
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
                                  return Column(children: [
                                      Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: [
                                                SizedBox(
                                                  width: size.width *0.4,
                                                  height: size.height * 0.15,
                                                  child: Card(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        const Text(
                                                          'Created Group   ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 15.00,
                                                          ),
                                                        ),
                                                        //   ),
                                                        Text(document[
                                                        'CreatedGroup']),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width *0.4,
                                                  height: size.height * 0.15,
                                                  child: Card(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        const Text(
                                                          'Created Meeting   ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 15.00,
                                                          ),
                                                        ),
                                                        //   ),
                                                        Text(document[
                                                        'CreatedMeeting']),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: [
                                                SizedBox(
                                                  width: size.width *0.4,
                                                  height: size.height * 0.15,
                                                  child: Card(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        const Text(
                                                          'Following   ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 15.00,
                                                          ),
                                                        ),
                                                        //   ),
                                                        Text(document[
                                                        'userFollowing']),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width *0.4,
                                                  height: size.height * 0.15,
                                                  child: Card(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        const Text(
                                                          'Coming Up Meetings   ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 15.00,
                                                          ),
                                                        ),
                                                        //   ),
                                                        Text(document[
                                                        'ComingUpMeetings'].toString()),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: [

                                                SizedBox(
                                                  width: size.width *0.4,
                                                  height: size.height * 0.15,
                                                  child: Card(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                      children: [
                                                        const Text(
                                                          'Req   ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 15.00,
                                                          ),
                                                        ),
                                                        Text(document['userReq']),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )



                                          ],
                                        ),
                                      )
                                    ],
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
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(uid)
                              .collection('Group')
                              //  .where('CreateById', isEqualTo: uid)
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

                                    if (currentUser.uid ==
                                        (document['CreateById'])) {
                                      return ListTile(
                                        leading: const Icon(Icons.person),
                                        title: Text(document['GroupName']),
                                        subtitle:
                                            Text(document['GroupActivity']),
                                        trailing: SingleChildScrollView(
                                            child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.details),
                                              tooltip: 'add this user',
                                              onPressed: () async {
                                                final groupId =
                                                    document['groupId'];
                                                final createdBy =
                                                    document['CreateById'];

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        GroupDetail(
                                                      groupId: groupId,
                                                      createdBy: createdBy,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              tooltip: 'add this user',
                                              onPressed: () async {
                                                final groupId =
                                                    document['groupId'];
                                                final groupName =
                                                    document['GroupName'];
                                                final groupActivity =
                                                    document['GroupActivity'];
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        GroupPage(
                                                      groupId: groupId,
                                                      groupName: groupName,
                                                      groupActivity:
                                                          groupActivity,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.date_range_rounded),
                                              tooltip: 'Create a meeting',
                                              onPressed: () async {
                                                final groupId =
                                                document['groupId'];
                                                print('group $groupId');

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                         MeetingCreation(groupId: groupId,)
                                                  ),
                                                );


                                              },
                                            ),
                                          ],
                                        )),
                                      );
                                    } else {
                                      return ListTile(
                                        leading: const Icon(Icons.group),

                                        title: Text(document['GroupName']),
                                        subtitle:
                                            Text(document['GroupActivity']),

                                        trailing: IconButton(
                                          icon: const Icon(Icons.details),
                                          tooltip: 'add this user',
                                          onPressed: () async {
                                            final groupId = document['groupId'];

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    GroupDetail(
                                                  groupId: groupId,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  });
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                        Button(onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GroupUserPage(),
                              ));
                        }, text: 'Create Group')

                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(uid)
                              .collection("followingUser")
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
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return ListTile(
                                      leading: const Icon(Icons.group),

                                      title: Text(document['email']),
                                      // subtitle: Text(document['role'])  ,
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        tooltip: 'delete this user',
                                        onPressed: () async {
                                          final uid = currentUser.uid;
                                          final userId = document['id'];
                                          final userEmail = document['email'];
                                          final email = currentUser.email;

                                          final followers = document.id;
                                          UserHelper.userUnfollow(
                                              uid, followers);
                                          UserHelper.deleteFollow(
                                              uid, userId, email!, userEmail);
                                          // Dashboard.userDashboard(uid);
                                        },
                                      ),

                                      // title: Text((document.data as Map<String, dynamic>)['email'] ),
                                      // title: Text(document.data()! ['email']),
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

                ],
              ),
            );
          } else {
            return LoginPage();
          }
        });
  }
}
