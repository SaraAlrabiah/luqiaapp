import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';
import 'package:luqiaapp/operation/meeting_operation.dart';
import 'current_meeting_detail.dart';
import 'login.dart';

class MeetingDetail extends StatefulWidget {
  MeetingDetail({Key? key, this.meetingId , this.groupId}) : super(key: key);
  final meetingId;
  final groupId;

  @override
  // ignore: no_logic_in_create_state
  _MeetingDetailState createState() => _MeetingDetailState(meetingId , groupId);
}

class _MeetingDetailState extends State<MeetingDetail>
    with TickerProviderStateMixin {
  var meetingId;
  var groupId;
  // late TabController _tabController;

  _MeetingDetailState(this.meetingId, this.groupId);

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 1, vsync: this);
  }

  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            UserHelper.saveUser(snapshot.data!);

            // ignore: non_constant_identifier_names
            var currentUser = FirebaseAuth.instance.currentUser;
            final uid = currentUser!.uid;
            final userEmail = currentUser.email;
            Dashboard.userDashboard(uid,userEmail! );

            // var email = currentUser.email;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.white,
                title:  Text('Meeting Information'.tr , style: TextStyle(color: Colors.black),),
                leading: IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.arrow_back_ios_outlined),
                  tooltip: 'back'.tr,
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Group').doc(groupId)
                          .collection('Meetings')
                          .where('MeetingID', isEqualTo: meetingId)
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

                                DateTime dateTime =
                                    document['MeetingDate'].toDate();
                                MeetingOperation.comingBy(meetingId, dateTime , groupId);
                                if (document['ComingByMin'] != 'Done') {
                                  return ListTile(
                                    leading: const Icon(Icons.date_range),
                                    title: Text(document['MeetingTitle']),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(document['MeetingDescription']),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(document['MeetingDay']),
                                            const Text(" / "),
                                            Text(document['MeetingMonth']),
                                            const Text("/ "),
                                            Text(document['MeetingYear']),
                                            const Text(" "),
                                            Text(document['MeetingMin']),
                                            const Text(":"),
                                            Text(document['MeetingHours']),
                                          ],
                                        ),
                                        Row(
                                          children:  [
                                            Text("Meeting Coming By ".tr),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(document['ComingByDay']),
                                            Text(" days ".tr),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(document['ComingByHours']),
                                             Text(" hours ".tr),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(document['ComingByMin']
                                                .toString()),
                                             Text(" min ".tr),
                                          ],
                                        ),
                                        Row(

                                          children: [

                                            IconButton(
                                                padding: EdgeInsets.only(left: 30),
                                                onPressed: null, icon: Icon( Icons.location_on_rounded) ),


                                            Text('(', style: TextStyle(fontSize: 7,  ),),
                                            Text(document['MeetingLocationLat']
                                                .toString(), style: TextStyle(fontSize: 7),),
                                            const Text("," , style: TextStyle(fontSize: 7),),
                                            Text(document['MeetingLocationLng']
                                                .toString() ,style: TextStyle(fontSize: 7),),
                                            Text(')', style: TextStyle(fontSize: 7),),



                                          ],
                                        ),

                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.details),
                                      // tooltip: 'add this user',
                                      onPressed: () async {
                                        final meetingId = document['MeetingID'];
                                        if (document['ComingByMin'] != 'Done' &&
                                            document['ComingByMin'] < 31) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CurrentMeetingDetail(
                                                meetingId: meetingId,
                                                    groupId : groupId

                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                } else {
                                  return ListTile(
                                    leading: const Icon(Icons.date_range),
                                    title: Text(document['MeetingTitle']),
                                    subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(document['MeetingDescription']),
                                        Row(
                                          children: [
                                            Text(document['MeetingDay']),
                                            const Text(" / "),
                                            Text(document['MeetingMonth']),
                                            const Text("/ "),
                                            Text(document['MeetingYear']),
                                            const Text(" "),
                                            Text(document['MeetingMin']),
                                            const Text(":"),
                                            Text(document['MeetingHours']),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                // document['ComingByMin'].toString()
                                              'Done'.tr
                                            ),
                                          ],
                                        ),
                                         Row(

                                               children: [

                                                    IconButton(
                                                      padding: EdgeInsets.only(left: 30),
                                                        onPressed: null, icon: Icon( Icons.location_on_rounded) ),


                                                          Text('(', style: TextStyle(fontSize: 7,  ),),
                                                          Text(document['MeetingLocationLat']
                                                              .toString(), style: TextStyle(fontSize: 7),),
                                                          const Text(",", style: TextStyle(fontSize: 7),),
                                                          Text(document['MeetingLocationLng']
                                                              .toString() ,style: TextStyle(fontSize: 7),),
                                                          Text(')', style: TextStyle(fontSize: 7),),



                                              ],
                                            ),

]
                                  ),




                                    trailing: IconButton(
                                      icon: const Icon(Icons.details),
                                      // tooltip: 'add this user',
                                      onPressed: () async {
                                        print(document['ComingByMin']);
                                        final meetingId = document['MeetingID'];
                                        if (document['ComingByMin'] != 'Done' &&
                                            document['ComingByMin'] < 31) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CurrentMeetingDetail(
                                                meetingId: meetingId,
                                              ),
                                            ),
                                          );
                                        }
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
                  ],
                ),
              ),
              //   ],
              // ),
              // ),
            );
          } else {
            return LoginPage();
          }
        });
  }
}
