import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';

import 'login.dart';
import 'meeting_detail.dart';

class GroupDetail extends StatefulWidget {


  var createdBy;

   GroupDetail({Key? key, this.groupId , this.createdBy }) : super(key: key);
   final  groupId ;


   @override
  // ignore: no_logic_in_create_state
  _GroupDetailState createState() => _GroupDetailState(groupId , createdBy);
}



class _GroupDetailState extends State<GroupDetail> with TickerProviderStateMixin {
  var groupId;
  late TabController _tabController;

  var createdBy;
  _GroupDetailState(this.groupId , this.createdBy );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

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

           // var email = currentUser.email;
            return  Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text('Group Information'),
                leading:  IconButton(
                  icon: const Icon(Icons.backspace_outlined),
                  tooltip: 'back',
                  onPressed: () {
                    Navigator.pop(
                      context,

                    );

                  },
                ),

                bottom: TabBar(
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(
                      icon: Icon(Icons.group),
                    ),
                    Tab(
                      icon: Icon(Icons.person),
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
                          stream: /*FirebaseFirestore.instance
                              .collection("Meetings").where('groupID', isEqualTo: groupId)
                              .snapshots(),*/
                          FirebaseFirestore.instance
                              /*.collection("Group").doc(groupId)*/.collection('Meetings').where('GroupId' , isEqualTo: groupId)
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

                                    return ListTile(
                                      leading: const Icon(Icons.date_range),

                                      title: Text(document['MeetingTitle']),
                                      subtitle:Column(
                                        children: [
                                          Text(document['MeetingDescription']),

                                          Row(
                                            children: [
                                              Text(document[
                                              'MeetingDay']),

                                              const Text(" / "),
                                              Text(document['MeetingMonth']),
                                              const Text("/ "),
                                              Text(
                                                  document['MeetingYear']
                                              ),

                                              const Text(" "),

                                              Text(
                                                  document['MeetingMin']
                                              ),
                                              const Text(":"),

                                              Text(document['MeetingHours']),
                                            ],
                                          ),

                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.details),
                                        tooltip: 'add this user',
                                        onPressed: () async {
                                          final meetingId = document['MeetingID'];

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MeetingDetail(
                                                    meetingId: meetingId,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),

                                    );


                                },

                              );

                            }

                            else {
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
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Group").doc(groupId) .collection("GroupMember")
                             // .doc('Group').collection(groupId)
                          //.where('groupID', isEqualTo: groupId)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {

                              // ignore: unused_local_variable

                         //     var currentUser = FirebaseAuth.instance.currentUser;
                             // var email = currentUser!.email;
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

                                    title: Text(document['email']),
                                    subtitle: Text(document['id']),

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
              // ),
            );
          } else {
            return LoginPage();
          }
        });
  }
}
