import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:luqiaapp/operation/location_operation.dart';

class MeetingOperation {
  static FirebaseFirestore db = FirebaseFirestore.instance;


  static addMeetingTime(
      String MeetingTitle,
      String meetingDescription,
      String groupId,
      DateTime meetingTime,
      String email,
      LatLng locationPoint) async {
    QuerySnapshot meetingCollection = await db.collection('Meetings').get();

    //Timestamp meetingDate = Timestamp.fromDate(meetingTime);
    int meetingCount = meetingCollection.size;
    int meetingNum = meetingCount++;
    String meetingNumber = meetingNum.toString();
    print('group $groupId');
    print('meeting $meetingNum');

    DateTime now = DateTime.now();

    final comingByDys = meetingTime.difference(now).inDays;
    final comingByHours = meetingTime.difference(now).inHours;
    final comingByMin = meetingTime.difference(now).inMinutes;
    //  final meeting = db/*.collection("Group").doc(groupId)*/.collection('Meetings').doc(meetingNumber);
    Map<String, dynamic> meetingInfo = {
      'GroupId': groupId,
      'MeetingID': meetingNumber,
      'CreateByEmail': email,
      'MeetingTitle': MeetingTitle,
      'MeetingDescription': meetingDescription,
      'MeetingLocationLat': locationPoint.latitude,
      'MeetingLocationLng': locationPoint.longitude,
      "MeetingYear": meetingTime.year.toString(),
      "MeetingMonth": meetingTime.month.toString(),
      "MeetingDay": meetingTime.day.toString(),
      "MeetingHours": meetingTime.hour.toString(),
      "MeetingMin": meetingTime.minute.toString(),
      'MeetingDate': meetingTime,
      "ComingByDay": comingByDys.toString(),
      "ComingByHours": comingByHours.toString(),
      "ComingByMin": comingByMin,
    };
    db.collection('Meetings').doc(meetingNumber).set(meetingInfo);
  }

  static comingBy(String meetingId, DateTime dateTime) async {
    DateTime now = DateTime.now();

    final userRef = db.collection("Meetings").doc(meetingId);
    final comingByDys = dateTime.difference(now).inDays;
    final comingByHours = dateTime.difference(now).inHours;
    final comingByMin = dateTime.difference(now).inMinutes.toInt();
    if(comingByDys < 1 ){

    if ( comingByMin > -1) {

      if ((await userRef.get(
      )).exists) {
        await userRef.update(
            {
              "ComingByDay": 'Today',
              "ComingByHours": comingByHours.toString(
              ),
              "ComingByMin": comingByMin,
            } );
      }
    }
      else if (comingByMin < 0 && comingByMin > -30) {

        if ((await userRef.get(
        )).exists) {
          await userRef.update(
              {
                "ComingByDay": 'Now',
                "ComingByHours": 'Now',
                "ComingByMin": comingByMin,
              } );
        }
      }
      else if (comingByMin < -45) {

        if ((await userRef.get(
        )).exists) {
          await userRef.update(
              {
                "ComingByDay": 'Done',
                "ComingByHours": 'Done',
                "ComingByMin": 'Done',
              } );
        }
      }

    }

    else{

      if ((await userRef.get()).exists) {
        await userRef.update(
            {
              "ComingByDay": comingByDys.toString(
              ),
              "ComingByHours": comingByHours.toString(
              ),
              "ComingByMin": comingByMin,
            } );
      }
    }
//  if(comingByMin <= -45 && comingByMin > -100){
//   if ((await userRef.get()).exists) {
//     await userRef.update(
//         {
//           "ComingByDay": 'Done',
//           "ComingByHours":'Done',
//           "ComingByMin": 'Done',
//         } );
//   }
// }
  }

  static estimatedTime(String meetingId) async {
    final meetingRef = db.collection("Meetings");
    DocumentSnapshot snapshot = await meetingRef.doc(meetingId).get();
    var meetingData = snapshot.data() as Map;
    var groupId = meetingData['GroupId'];
    var commingBy = meetingData['ComingByMin'];
    FirebaseFirestore.instance
        .collection('Group')
        .doc(groupId)
        .collection('GroupMember')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (commingBy <= 31) {
          LocationService.estimatedTime(meetingId, doc["id"]);
          print(doc["id"]);
        }
      });
    });


  }
}
