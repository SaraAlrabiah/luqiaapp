import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';
import 'package:luqiaapp/operation/meeting_operation.dart';
import 'login.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CurrentMeetingDetail extends StatefulWidget {
  CurrentMeetingDetail({Key? key, this.meetingId , this.groupId}) : super(key: key);
  final meetingId;
final groupId;
  @override
  _CurrentMeetingDetailState createState() =>
      _CurrentMeetingDetailState(meetingId , groupId);
}

class _CurrentMeetingDetailState extends State<CurrentMeetingDetail>
    with TickerProviderStateMixin {


  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press and start ';
  double _confidence = 1.0;
  var meetingId;

  var groupId;
  _CurrentMeetingDetailState(this.meetingId, this.groupId);

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            Size size = MediaQuery.of(context).size;

            UserHelper.saveUser(snapshot.data!);
            var currentUser = FirebaseAuth.instance.currentUser;
            final uid = currentUser!.uid;
            final userEmail = currentUser.email;
            Dashboard.userDashboard(uid,userEmail! );
            MeetingOperation.estimatedTime(meetingId , groupId);
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.white,
                title:  Text(
                  'Current Meeting Information'.tr,
                  style: TextStyle(color: Colors.black),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_outlined,
                      color: Colors.black),
                  tooltip: 'back',
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: AvatarGlow(
                animate: _isListening,
                glowColor: Theme.of(context).primaryColor,
                endRadius: 75.0,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 100),
                repeat: true,
                child: FloatingActionButton(
                  onPressed: _listen,
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Group').doc(groupId)
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
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(document['duration']),
                                    Text(document['distance']),
                                    Text(document['Comment']),
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
                    Column(
                      children: [
                        SingleChildScrollView(
                          reverse: true,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                size.width * 0.1,
                                size.height * 0.5,
                                size.width * 0.1,
                                size.height * 0.1),
                            child: Text(_text),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              print(_text);
                              if (
                              _text != 'Press and start ' &&
                                  _text.isNotEmpty) {
                                MeetingOperation.addComment(meetingId, _text , groupId);
                              }
                            },
                            child: Text("Send".tr))
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return LoginPage();
          }
        });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
        debugLogging: true,
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}

