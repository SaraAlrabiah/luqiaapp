import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';

import 'login.dart';
import 'meeting_detail.dart';

class GroupDetail extends StatefulWidget {



   GroupDetail({Key? key, this.groupId , this.createdBy }) : super(key: key);
   final  groupId ;
   final createdBy;


   @override
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
            var currentUser = FirebaseAuth.instance.currentUser;
            final uid = currentUser!.uid;
            final userEmail = currentUser.email;
            Dashboard.userDashboard(uid,userEmail! );

           // var email = currentUser.email;
            return  Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.white,
                title:  Text('Group Information'.tr , style: TextStyle(color: Colors.black),),
                leading:  IconButton(
                  icon: const Icon(Icons.arrow_back_ios , color: Colors.black,),
                  tooltip: 'back'.tr,
                  onPressed: () {
                    Navigator.pop(
                      context,

                    );

                  },
                ),

                bottom: TabBar(
                    indicatorColor:  Color.fromRGBO(	83, 83, 83, 1),
                    labelColor: Color.fromRGBO(	83, 83, 83, 1),
                    controller: _tabController,
                    tabs:  <Widget>[
                      Tab(text: 'Meetings'.tr, icon: Icon(Icons.meeting_room , color: Colors.black,)),
                      Tab(text: 'Group Member'.tr, icon: Icon(Icons.person , color: Colors.black,)),

                    ]
                ),
              ),
              body:
              TabBarView(
                controller: _tabController,
                children: <Widget>[
                  SingleChildScrollView(
                    child:Column(

                      children: <Widget>[
                        StreamBuilder(
                          stream:
                          FirebaseFirestore.instance.collection('Group').doc(groupId).collection('Meetings')
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
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
                                        tooltip: 'Group details'.tr,
                                        onPressed: () async {
                                          final meetingId = document['MeetingID'];

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MeetingDetail(
                                                    meetingId: meetingId,
                                                    groupId: groupId,
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


                                      leading: const Icon(Icons.group),

                                    title: Text(document['email']),

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
