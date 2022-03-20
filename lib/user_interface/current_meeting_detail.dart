import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';
import 'package:luqiaapp/operation/meeting_operation.dart';
import 'login.dart';

class CurrentMeetingDetail extends StatefulWidget {
  CurrentMeetingDetail({Key? key, this.meetingId}) : super(key: key);
  final meetingId;

  @override
  _CurrentMeetingDetailState createState() =>
      _CurrentMeetingDetailState(meetingId);
}
class _CurrentMeetingDetailState extends State<CurrentMeetingDetail> with TickerProviderStateMixin {
  var meetingId;
  _CurrentMeetingDetailState(this.meetingId);

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            UserHelper.saveUser(snapshot.data!);
            var currentUser = FirebaseAuth.instance.currentUser;
            final uid = currentUser!.uid;
            Dashboard.userDashboard(uid);
            MeetingOperation.estimatedTime(meetingId);
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.grey,
                title: const Text('Current Meeting Information'),
                leading: IconButton(
                  icon: const Icon(Icons.backspace_outlined),
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
                          .doc(meetingId)
                          .collection('EstimatedTime')
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
                                title: Text(document['email']),
                                subtitle: Row(
                                  children: [
                                    Text(document['duration']),
                                    Text(document['distance']),
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
                    // Row(
                    //   children: [
                    //     floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                    //     floatingActionButton: AvatarGlow(
                    //       animate: _isListening,
                    //       glowColor: Theme.of(context).primaryColor,
                    //       endRadius: 75.0,
                    //       duration: const Duration(milliseconds: 2000),
                    //       repeatPauseDuration: const Duration(milliseconds: 100),
                    //       repeat: true,
                    //       child: FloatingActionButton(
                    //         onPressed: _listen,
                    //         child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    //       ),
                    //     ),
                    //   ],
                    // )
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
