import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';
import 'package:luqiaapp/operation/meeting_operation.dart';
import 'login.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CurrentMeetingDetail extends StatefulWidget {
  CurrentMeetingDetail({Key? key, this.meetingId}) : super(key: key);
  final meetingId;

  @override
  _CurrentMeetingDetailState createState() =>
      _CurrentMeetingDetailState(meetingId);
}

class _CurrentMeetingDetailState extends State<CurrentMeetingDetail>
    with TickerProviderStateMixin {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press and start ';
  double _confidence = 1.0;
  var meetingId;
  _CurrentMeetingDetailState(this.meetingId);

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
            Dashboard.userDashboard(uid);
            MeetingOperation.estimatedTime(meetingId);
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.white,
                title: const Text(
                  'Current Meeting Information',
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
                            child: TextHighlight(
                              text: _text,
                              words: _highlights,
                              textStyle: const TextStyle(
                                fontSize: 22.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              print(_text);
                              if (
                              _text != 'Press and start ' &&
                                  _text.isNotEmpty) {
                                MeetingOperation.addComment(meetingId, _text);
                              }
                            },
                            child: Text("Send"))
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
