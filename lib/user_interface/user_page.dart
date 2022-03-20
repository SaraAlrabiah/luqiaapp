// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';
import 'package:luqiaapp/operation/group_operation.dart';
import 'package:luqiaapp/operation/location_operation.dart';
import 'package:luqiaapp/user_interface/group_detail.dart';
import 'package:luqiaapp/user_interface/setting.dart';
import 'package:provider/provider.dart';
import 'group_creation.dart';
import 'group_info.dart';
import 'login.dart';
import 'meeting_creation.dart';

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
    _tabController = TabController(length: 6, vsync: this);
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
            Dashboard.userDashboard(uid);
            // var email = currentUser.email;
            var name = currentUser.displayName;

            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.grey,
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome'.tr,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25.0),
                      ),
                      Text('    $name'),
                    ]),
                leading: IconButton(
                  onPressed: () {
                   Navigator.push( context,MaterialPageRoute(builder: (context) =>    SettingPage(uid: uid,)), );
                  },
                  icon: const Icon(Icons.settings),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
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
                    Tab(
                      icon: Icon(Icons.brightness_5_sharp),
                    ),
                    Tab(
                      icon: Icon(Icons.group),
                    ),
                    Tab(
                      icon: Icon(Icons.group),
                    ),
                  ],
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
                                  final users = docs[index].data();
                                  final uid = currentUser.uid;
                                  if ((users as Map<String, dynamic>)['role'] ==
                                          'normalUser' &&
                                      (users)['id'] !=
                                          currentUser
                                              .uid /*&& (users as Map<String, dynamic>)['email'] != document['email']*/) {
                                    return ListTile(
                                      selectedColor: Colors.blue,
                                      title: Text(document['email']),
                                      subtitle: Text(document['role']),
                                      trailing: IconButton(
                                        icon:  const Icon(
                                          Icons.add,
                                        ),
                                        tooltip: 'add this user',
                                        onPressed: () async {
                                          final email = currentUser.email;
                                          final userId = document['id'];
                                          final userEmail = document['email'];

                                          UserHelper.followUser(
                                              uid, userId, email!, userEmail);

                                          // UserHelper.followUsers( uid, userId, email, userEmail);
                                          //       UserHelper.doesNameAlreadyExist("normalUser", userId);
                                        },
                                      ),
                                    );
                                  } else {
                                    return Center(child: Row());
                                  }
                                },
                              );
                            } else {
                              return Center(child: Row());
                            }
                          },
                        ),

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
                                  // final users = docs[index].data();
                                  //  final userDoc = snapshot.data;
                                  //  final userInfo = userDoc;
                                  // ignore: prefer_const_constructors
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
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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

                                  // ignore: prefer_const_constructors
                                  return Column(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Center(
                                        // height: 400,
                                        // width: 500,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: size.width *0.4,
                                              height: size.height * 0.2,
                                              child: Card(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                              height: size.height * 0.2,
                                              child: Card(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,

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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        // ignore: deprecated_member_use
                        RaisedButton(
                            child: const Text("Create Group"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const GroupUserPage(),
                                  ));
                            })
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
