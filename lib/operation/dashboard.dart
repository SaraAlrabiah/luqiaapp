import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<void> usersCount(String uid) async {
    QuerySnapshot companyUsersCollection = await db
        .collection('users')
        .where('role', isEqualTo: 'companyUser')
        .get();
    int companyUsersCount = companyUsersCollection.size;

    DateTime now = DateTime.now();
    String month = now.month.toString();
    // ignore: non_constant_identifier_names
    QuerySnapshot ActiveUsersCollection = await db
        .collection('users')
        .where('last_login_month',
            isEqualTo: month) //.where('role', isNotEqualTo: 'admin' )
        .get();
    // ignore: non_constant_identifier_names
    int ActiveUsersCount = ActiveUsersCollection.size - 1;
    if (ActiveUsersCount < 0) {
      ActiveUsersCount == 0;
    }
    String day = now.day.toString();
    QuerySnapshot todayActiveUsersCollection = await db
        .collection('users')
        .where('last_login_day', isEqualTo: day)
        .get();
    int todayActiveUsersCount = todayActiveUsersCollection.size - 1;
    if (todayActiveUsersCount < 0) {
      todayActiveUsersCount == 0;
    }

    QuerySnapshot normalUserCollection = await db
        .collection('users')
        .where('role', isEqualTo: 'normalUser')
        .get();
    int normalUserCount = normalUserCollection.size;
    // userCounty(normalUserCount);
    Map<String, dynamic> dashboardDataUser = {
      'users': normalUserCount.toString(),
      'company': companyUsersCount.toString(),
      'activeUser': ActiveUsersCount.toString(),
      'todayActiveUser': todayActiveUsersCount.toString()
    };
    db.collection("users").doc(uid).collection('Dashboard').doc(uid).delete();
    db
        .collection("users")
        .doc(uid)
        .collection('Dashboard')
        .doc(uid)
        .set(dashboardDataUser);
  }

  static Future<void> userDashboard(String uid, String userEmail) async {
    final List<Object> collectionElements = [];
    List<Object> toReturn = [];

    QuerySnapshot usersCollection =
        await db.collection('users').doc(uid).collection('followingUser').get();
    int usersInfoCount = usersCollection.size;

    QuerySnapshot reqCollection =
        await db.collection('users').doc(uid).collection('Req').get();
    int reqCollectionCount = reqCollection.size;

    QuerySnapshot createdGroupCollection = await db
        .collection('Group')
        .where('CreateByEmail', isEqualTo: userEmail)
        .get();
    int createdGroupCount = createdGroupCollection.size;

    final result = await db.collection("Group").get();

    for (int i = 0; i < result.docs.length; i++) {
      final x =
          db.collection('Group').doc('$i').collection('GroupMember').doc(uid);
      if ((await x.get()).exists) {
        toReturn.add(i);
      }
    }


    int upComingMeetings = 0;

    for (int j = 0; j < toReturn.length; j++) {
      var x = toReturn[j];
      final meeting = await db.collection("Group").doc('$x').collection('Meetings').where('ComingByMin' , isNotEqualTo: 'Done').get();

      upComingMeetings = meeting.size;

    }
    int createdMeetingCount = 0;

    for (int j = 0; j < toReturn.length; j++) {

      var joinedGroup = toReturn[j];
      print(toReturn);
      QuerySnapshot createdMeetings = await db
          .collection('Group').doc('$joinedGroup').collection('Meetings')
          .where('CreateByEmail', isEqualTo: userEmail)
          .get();
         int currentGroupMeetings = createdMeetings.size;
      createdMeetingCount = createdMeetingCount + currentGroupMeetings;

          print(createdMeetingCount);


    }

    Map<String, dynamic> dashboardDataUser = {
      'userFollowing': usersInfoCount.toString(),
      'userReq': reqCollectionCount.toString(),
      'CreatedGroup': createdGroupCount.toString(),
      'CreatedMeeting': createdMeetingCount.toString(),
      'Groups': toReturn.length.toString(),
      'ComingUpMeetings':upComingMeetings,
    };
    db
        .collection("users")
        .doc(uid)
        .collection('userDashboard')
        .doc(uid)
        .delete();
    db
        .collection("users")
        .doc(uid)
        .collection('userDashboard')
        .doc(uid)
        .set(dashboardDataUser);
  }
}
