import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';
import 'package:luqiaapp/operation/meeting_operation.dart';
import 'current_meeting_detail.dart';
import 'login.dart';

class MeetingDetail extends StatefulWidget {
  MeetingDetail({Key? key, this.meetingId}) : super(key: key);
  final meetingId;

  @override
  // ignore: no_logic_in_create_state
  _MeetingDetailState createState() => _MeetingDetailState(meetingId);
}

class _MeetingDetailState extends State<MeetingDetail>
    with TickerProviderStateMixin {
  var meetingId;
  // late TabController _tabController;

  _MeetingDetailState(this.meetingId);

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
            Dashboard.userDashboard(uid);

            // var email = currentUser.email;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.white,
                title: const Text('Meeting Information' , style: TextStyle(color: Colors.black),),
                leading: IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.arrow_back_ios_outlined),
                  tooltip: 'back',
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
                      stream: FirebaseFirestore.instance
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
                                MeetingOperation.comingBy(meetingId, dateTime);
                                if (document['ComingByMin'] != 'Done') {
                                  return ListTile(
                                    leading: const Icon(Icons.date_range),
                                    title: Text(document['MeetingTitle']),
                                    subtitle: Column(
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
                                          children: const [
                                            Text("Meeting Coming By "),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(document['ComingByDay']),
                                            Text(" days "),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(document['ComingByHours']),
                                            const Text(" hours "),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(document['ComingByMin']
                                                .toString()),
                                            const Text(" min "),
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
                                            Text(document['ComingByMin']
                                                .toString()),
                                          ],
                                        ),
                                      ],
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
