import 'package:cloud_firestore/cloud_firestore.dart';


class MeetingOperation {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


/*  static Future<void> createNewMeeting(String MeetingTitle,
      String meetingDescription, String groupId , String currentUserEmail) async {
    AdminTrack.usersTrack( currentUserEmail,'Create a meeting',DateTime.now(
    ) );
    QuerySnapshot meetingCollection = await db.
    collection(
        'Meetings' )/*.where('groupId' ,isEqualTo: groupId)*/.get(
    );
    /*QuerySnapshot meetingCollection = await db.
    collection(
        'Group' ).doc(groupId).collection('Meetings')
        .get(
    );*/
    int meetingCount = meetingCollection.size;
    print(meetingCount);
    int meetingNum = meetingCount++;
    print(meetingNum);

    String meetingNumber = meetingNum.toString(
    );
    DateTime now = DateTime.now();
    String month = now.month.toString();
    String day = now.day.toString();
    String min = now.minute.toString();
    String hours = now.hour.toString();
    String year = now.year.toString();

    // DocumentReference reference = FirebaseFirestore.instance.collection("Group").doc();

    Map<String, dynamic> groupInfo ={
      'GroupId' : groupId,
      'MeetingID': meetingNumber,
      'CreateByEmail': currentUserEmail,
      'MeetingTitle': MeetingTitle,
      'MeetingDescription': meetingDescription,
      "MeetingYear": 'year',
      "MeetingMonth": 'month',
      "MeetingDay": 'day',
      "MeetingHours": 'hours',
      "MeetingMin": 'min',


    };
    print('done');
    db./*collection(
        'Group' ).doc(
        groupId ).*/collection('Meetings').doc(meetingNumber).set(
        groupInfo );

    //// part to add group to creator page

  }*/
  static addMeetingTime(String MeetingTitle,
      String meetingDescription, String groupId , DateTime meetingTime , String email) async {

    QuerySnapshot meetingCollection = await db.collection( 'Meetings' ).get( );

    //Timestamp meetingDate = Timestamp.fromDate(meetingTime);
    int meetingCount = meetingCollection.size;
    int meetingNum = meetingCount++;
    String meetingNumber = meetingNum.toString(
    );
    print('group $groupId');
    print('meeting $meetingNum');

    DateTime now = DateTime.now();


    final comingByDys = meetingTime.difference(now).inDays;
    final comingByHours = meetingTime.difference(now).inHours;
    final comingByMin = meetingTime.difference(now).inMinutes;
  //  final meeting = db/*.collection("Group").doc(groupId)*/.collection('Meetings').doc(meetingNumber);
    Map<String, dynamic> groupInfo ={
        'GroupId' : groupId,
       'MeetingID': meetingNumber,
        'CreateByEmail': email,
        'MeetingTitle': MeetingTitle,
        'MeetingDescription': meetingDescription,
        "MeetingYear": meetingTime.year.toString(),
        "MeetingMonth": meetingTime.month.toString(),
        "MeetingDay": meetingTime.day.toString(),
        "MeetingHours": meetingTime.hour.toString(),
        "MeetingMin": meetingTime.minute.toString(),
      'MeetingDate': meetingTime,
        "ComingByDay": comingByDys.toString(),
        "ComingByHours": comingByHours.toString(),
        "ComingByMin": comingByMin.toString(),


   };
    db.collection('Meetings').doc(meetingNumber).set( groupInfo );

  }
  static comingBy(String meetingId , DateTime dateTime) async {
    DateTime now = DateTime.now();

    final userRef = db.collection("Meetings").doc(meetingId);
    final comingByDys = dateTime.difference(now).inDays;
    final comingByHours = dateTime.difference(now).inHours;
    final comingByMin = dateTime.difference(now).inMinutes;
    print(comingByMin);
    if(comingByDys == 0){
      if ((await userRef.get()).exists) {
        await userRef.update({
          "ComingByDay": 'Today',
          "ComingByHours": comingByHours.toString(),
          "ComingByMin": comingByMin.toString(),
        });
      }
    }
   else if (comingByMin <0 && comingByMin >-30){
      if ((await userRef.get()).exists) {
        await userRef.update({
          "ComingByDay": 'Now',
          "ComingByHours": 'Now',
          "ComingByMin": comingByMin.toString() ,
        });
      }}
      else if(comingByMin < -45 ){
        if ((await userRef.get()).exists) {
          await userRef.update({
            "ComingByDay": 'Done',
            "ComingByHours": 'Done',
            "ComingByMin": 'Done',
          });
        }
      }
      else{
        if ((await userRef.get()).exists) {
          await userRef.update({
            "ComingByDay": comingByDys.toString(),
            "ComingByHours": comingByHours.toString(),
            "ComingByMin": comingByMin.toString(),
          });
        }
      }



    // await _saveDevice(user);
  }

}